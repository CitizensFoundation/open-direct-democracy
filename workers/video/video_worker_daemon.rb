$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'yaml'
require 'nokogiri'
require 'open-uri'
require 'active_record'
require 'timeout'
require 'iconv'
require 'sys/filesystem'
require 'yaml'
require 'utils/logger.rb'
require 'utils/shell.rb'
require 'active_record'
require 'actionmailer'

require File.dirname(__FILE__) + '/../../config/boot'
require "#{RAILS_ROOT}/config/environment" 

include Sys

f = File.open( File.dirname(__FILE__) + '/config/worker.yml')
worker_config = YAML.load(f)
ENV['RAILS_ENV'] = worker_config['rails_env']
config = YAML::load(File.open(File.dirname(__FILE__) + "/../../config/database.yml"))

MASTER_TEST_MAX_COUNTER = 500000
MIN_FREE_SPACE_GB = 10
SLEEP_WAITING_FOR_FREE_SPACE_TIME = 120
SLEEP_WAITING_FOR_LOAD_TO_GO_DOWN = 120
SLEEP_WAITING_BETWEEN_RUNS = 5
EMAIL_REPORTING_INTERVALS = 86000
LINK_PREFIX = "http://www.althingi.is/altext/"

class VideoWorker
  def initialize(config)
    @logger = Logger.new(File.dirname(__FILE__) + "/video_"+ENV['RAILS_ENV']+".log")
    @shell = Shell.new(self)
    @worker_config = config
    @counter = 0
    @last_report_time = 0
  end

  def log_time
    t = Time.now
    "%02d/%02d %02d:%02d:%02d.%06d" % [t.day, t.month, t.hour, t.min, t.sec, t.usec]
  end

  def info(text)
    @logger.info("cs_info %s: %s" % [log_time, text])
  end

  def warn(text)
    @logger.warn("cs_warn %s: %s" % [log_time, text])
  end

  def error(text)
    @logger.error("cs_error %s: %s" % [log_time, text])
  end

  def debug(text)
    @logger.debug("cs_debug %s: %s" % [log_time, text])
  end

  def ensure_mysql_connection
    unless ActiveRecord::Base.connection.active?
      unless ActiveRecord::Base.connection.reconnect!
        error("Couldn't reestablish connection to MYSQL")
      end
    end
  end

  def load_avg
    results = ""
    IO.popen("cat /proc/loadavg") do |pipe|
      pipe.each("\r") do |line|
        results = line
        $defout.flush
      end
    end
    results.split[0..2].map{|e| e.to_f}
  end

  def check_load_and_wait
    loop do
      break if load_avg[0] < @worker_config["max_load_average"]
      info("Load Average #{load_avg[0]}, #{load_avg[1]}, #{load_avg[2]}")      
      info("Load average too high pausing for #{SLEEP_WAITING_FOR_LOAD_TO_GO_DOWN}")
      sleep(SLEEP_WAITING_FOR_LOAD_TO_GO_DOWN)
    end
  end

  def run
    info("Starting loop")
    loop do
      stat = Filesystem.stat(@worker_config["master_path"]+"/")
      freeGB = (stat.block_size * stat.blocks_available) /1024 / 1024 / 1024
      if @last_report_time+EMAIL_REPORTING_INTERVALS<Time.now.to_i
        #email_progress_report(freeGB) unless ENV['RAILS_ENV']=="development"
        @last_report_time = Time.now.to_i
      end
      info("Free video space in GB #{freeGB} - Run count: #{@counter}")
      info("Load Average #{load_avg[0]}, #{load_avg[1]}, #{load_avg[2]}")      
      if load_avg[0] < @worker_config["max_load_average"]
        if freeGB > MIN_FREE_SPACE_GB
          if ENV['RAILS_ENV'] == 'development' && @counter > MASTER_TEST_MAX_COUNTER
            warn("Reached maximum number of tests - sleeping for an hour")
            sleep(3600)
          else
            @counter = @counter + 1
            begin
              poll_for_work
            rescue => ex
              error("Problem with video worker")
              error(ex)
              error(ex.backtrace)
              ensure_mysql_connection
            end
          end
          info("Sleeping for #{SLEEP_WAITING_BETWEEN_RUNS} sec")
          sleep(SLEEP_WAITING_BETWEEN_RUNS)
        else
          info("No more space on disk for cache - sleeping for #{SLEEP_WAITING_FOR_FREE_SPACE_TIME} sec")
          sleep(SLEEP_WAITING_FOR_FREE_SPACE_TIME)
        end
      else
        info("Load average too high at: #{load_avg[0]} - sleeping for #{SLEEP_WAITING_FOR_LOAD_TO_GO_DOWN} sec")
        sleep(SLEEP_WAITING_FOR_LOAD_TO_GO_DOWN)
      end
    end
    info "THE END"
  end

  def poll_for_work
    unless @worker_config["only_get_masters"] and @worker_config["only_get_masters"]==true
      info "process_case_discussion"
      run_counter = 0
      while process_case_discussion
        info "poll_for_work case_discussion run counter: #{run_counter+=1}"
      end
      info "process_modify_durations"
      run_counter = 0
      while process_modify_durations
        info "poll_for_work process_modify_durations run counter: #{run_counter+=1}"
      end
    end
    unless @worker_config["skip_masters"] and @worker_config["skip_masters"]==true
      info "process_master"
      process_master
    end
    unless @worker_config["only_get_masters"] and @worker_config["only_get_masters"]==true
      info "process_speech"
      run_counter = 0
      while process_speech
        info "poll_for_work process_speech run counter: #{run_counter+=1}"
      end
    end
  end

  def process_modify_durations
    previous_video = nil
    case_discussion = CaseDiscussion.find(:first, :conditions=>"in_video_processing = 0 AND has_modified_durations = 0 AND video_processing_complete = 1", :order=>"meeting_date ASC", :lock=>true)
    if case_discussion
      case_discussion.case_speech_videos.get_all_for_modified_duration.each do |video|
        info "(#{video.inpoint_s}>#{previous_video.outpoint_s}) (#{video.inpoint_s-previous_video.outpoint_s})" if previous_video
        if previous_video and ((video.inpoint_s>previous_video.outpoint_s) and (video.inpoint_s-previous_video.outpoint_s<12) or video.inpoint_s<previous_video.outpoint_s)
          info "modified duration for id #{previous_video.id} by next start offset"
          previous_video.set_modified_duration_from_end_time(video.start_offset)
          previous_video.save
        elsif previous_video and video.inpoint_s-previous_video.outpoint_s>=12
          info "adding to durationfor id #{previous_video.id} for larger time skips"
          previous_video.modified_duration_s = previous_video.duration_s+6.seconds
          previous_video.save
        end
        if video==case_discussion.case_speech_videos.get_all_for_modified_duration.last and video.modified_duration_s == nil
          info "adding to 2 seconds to last video id #{video.id} in discussion id #{case_discussion.id}"
          video.modified_duration_s = video.duration_s+2.seconds
        end
        video.has_checked_duration = true
        video.save
        previous_video = video
      end
      case_discussion.has_modified_durations = true
      case_discussion.save
      return true
    else
      info "no more videos to modified duration to process"
      return false
    end
  end

  def process_master
    master_video = CaseSpeechMasterVideo.find(:first, :conditions=>"published = 0 AND in_processing = 0 AND url != ''", :lock=>true, :order=>"url")
    if master_video
      master_video.in_processing = true
      master_video.save
      download_master_video(master_video)
      convert_master_to_flash(master_video)
      ensure_mysql_connection
      master_video.reload :lock=>true
      master_video.in_processing = false
      master_video.published = true
      master_video.save
    else
      info "no more master videos to process"
    end
    check_load_and_wait
  end

  def process_speech
    found = false
    CaseSpeechMasterVideo.find(:all, :conditions=>"published = 1 AND in_processing = 0 AND url != ''", :order=>"url", :lock=>true).each do |master_video|
      master_video.in_processing = true
      master_video.save
      unless master_video.case_speech_videos.all_done? and not master_video.case_speech_videos.any_in_processing?
        found = true
        convert_all_speeches_to_flash(master_video)
        master_video.reload :lock=>true
        master_video.in_processing = false
        master_video.save
        break
      end
      master_video.reload :lock=>true
      master_video.in_processing = false
      master_video.save
    end
    check_load_and_wait
    if found
      return true
    else
      return false
    end
  end

  def process_case_discussion
    case_discussion = CaseDiscussion.find(:first, :conditions=>["in_video_processing = 0 AND video_processing_complete = 0 AND meeting_date > ?",DateTime.parse("10/01/2008")], :order=>"meeting_date ASC", :lock=>true)
    if case_discussion
      case_discussion.in_video_processing = true
      case_discussion.save
      info "Processing Case Discussion Id: #{case_discussion.id}"
      html_doc = Nokogiri::HTML(open(case_discussion.listen_url))
      @parent = nil
      last_current = nil
      last_link = nil
      last_indent = 0
      sequence_number = 0
      html_doc.xpath('//a').each do |link|
        if link.text=="Horfa"
          paragraph = link.parent
          if paragraph["style"]
            if paragraph["style"][0..11]=="text-indent:" or paragraph["style"][0..13]=="margin-top:5px"
              if paragraph["style"][0..13]=="margin-top:5px"
                last_current = @parent = CaseSpeechVideo.new
                info "TOP LEVEL"
                last_indent = 0
              else
                indent = paragraph["style"][13..14].to_i
                info indent
                if indent>last_indent
                  info "NEXT LEVEL"
                  @parent = last_current
                elsif indent<last_indent
                  info "PREVIOUS LEVEL"
                  if @parent.parent
                    @parent = @parent.parent
                  else
                    info "ERROR: Couldn't find parent keeping on same level"
                  end
                else
                  info "SAME LEVEL"
                end
                last_current = @parent.children.new
                last_indent=indent            
              end
              last_current.case_discussion_id=case_discussion.id
              last_current.sequence_number = sequence_number+=1
              last_current.title = last_link.text.strip
              setup_video(last_current, link["href"])
              info "LAST_TITLE: #{last_link.text}"
            end
          end
        end
        last_link = link
      end
      case_discussion.reload :lock=>true
      case_discussion.in_video_processing = false
      case_discussion.video_processing_complete = true
      case_discussion.save
      return true
    else
      info "No more case discussions to process"
      return false
    end
  end
    
  def print_all_sub_videos(video)
    if video.children.size > 0
      video.children.each do |subvideo| 
        print_video(subvideo)
        if subvideo.children.size > 0
          print_all_sub_videos(subvideo)
        end
      end
    end
  end

  def print_video(video)
    info "level: #{video.ancestors.length} id:#{video.id} title:#{video.title}"
  end

  def print_tree
    csv = CaseSpeechVideo.find(:all, :conditions=>"parent_id IS NULL")
    for video in csv
      print_video(video)
      print_all_sub_videos(video)
    end
  end
  
  def print_timecode
    CaseSpeechVideo.find(:all, :conditions=>"published = 1", :order=>"start_offset").each do |video|
      if video.modified_duration_s
        info "#{video.case_discussion.id} #{video.inpoint_s}-#{video.modified_outpoint_s} (#{video.modified_duration_s}s) - #{video.title}"
      else
        info "#{video.case_discussion.id} #{video.inpoint_s}-#{video.outpoint_s} (#{video.duration_s}s) - #{video.title}"
      end
    end
  end
  
  def setup_video(current, link)
    info LINK_PREFIX+link
    link_sub_doc = Nokogiri::HTML(open(LINK_PREFIX+link))
    starttime = ""
    duration = ""
    main_video_url = ""
    title = ""
    link_sub_doc.xpath('//param').each do |param|
      if param["name"]=="FileName"
        info "XMLLINK #{param["value"]}"
        link_xml_doc = Nokogiri::HTML(open(param["value"]))
        info link_xml_doc
        link_xml_doc.xpath('//starttime').each do |s|
          starttime = s['value']
        end
        link_xml_doc.xpath('//duration').each do |s|
          duration = s['value']
        end
        link_xml_doc.xpath('//ref').each do |s|
          main_video_url = s['href']
        end
        link_xml_doc.xpath('//title').each do |s|
          title = s.text # Icelandic characters dont work here so this is not used
        end
        info main_video_url
        master_video = CaseSpeechMasterVideo.find_by_url(main_video_url)
        unless master_video
          master_video = CaseSpeechMasterVideo.new
          master_video.url = main_video_url
          master_video.save
        end
        current.start_offset=Time.parse(starttime)
        current.duration=Time.parse(duration)
        current.case_speech_master_video_id = master_video.id
        old_video = CaseSpeechVideo.find(:first, :conditions=>["start_offset = ? AND duration = ? and case_speech_master_video_id = ?",
                                                                       current.start_offset,current.duration,current.case_speech_master_video_id])
        unless old_video
          current.save
        else
          info "FOUND OLD VIDEO: "+old_video.inspect
        end
      end
    end
    info "DID NOT FIND VIDEO!!!!!!!!!!!!!!" if duration==""
    info current.inspect
  end
 
  def download_master_video(master_video)
    master_video_path = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/"
    master_video_filename = "#{master_video_path}master.wmv"
    url_to_mmsh = "mmsh"+master_video.url[4..master_video.url.length]
    FileUtils.mkpath(master_video_path)
    @shell.execute("cvlc #{url_to_mmsh} --tcp-caching=120000 --http-caching=120000 --mms-caching=120000 --mms-timeout=120000 :demux=dump :demuxdump-file=#{master_video_filename} vlc://quit", "codec failed")
  end

  def convert_master_to_flash(master_video)
    master_video_filename = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/master.wmv"
    master_video_flv_tmp_filename = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/master.tmp.flv"
    master_video_flv_filename = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/master.flv"
    @shell.execute("mencoder -of lavf -ovc lavc -lavcopts vcodec=flv:vbitrate=1000:keyint=25:vqmin=3:acodec=libmp3lame:abitrate=160\
     -srate 44100 -af channels=1 -delay 0.20 -oac lavc -lavcopts acodec=libmp3lame:abitrate=160 -ofps 25 -vf \"harddup,crop=812:476:16:3,scale=640:375\"\
     #{master_video_filename} -o #{master_video_flv_tmp_filename}")
    @shell.execute("mv #{master_video_flv_tmp_filename} #{master_video_flv_filename}")
    @shell.execute("rm #{master_video_filename}")
  end

  def convert_all_speeches_to_flash(master_video)
    master_video_filename = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/master.flv"
    cut_points = []
    master_video.case_speech_videos.each do |video|
      speech_video_path = "#{RAILS_ROOT}/public/"+ENV['RAILS_ENV']+"/case_speech_videos/#{video.id}/"
      speech_video_first_tmp_filename = speech_video_path+"speech.tmp_1.flv"
      FileUtils.mkpath(speech_video_path)
      inpoint_ms = video.inpoint_s*1000

      inpoint_ms += 200 # mencoder video delay
      inpoint_ms -= 2000 # shift forward (after experimenting)                   
                  
      if video.modified_duration_s
        duration_ms = video.modified_duration_s*1000
      else
        duration_ms = video.duration_s*1000
      end
      outpoint_ms = inpoint_ms + duration_ms
      cut_points << [inpoint_ms,outpoint_ms,speech_video_first_tmp_filename]
    end

    @shell.execute("flvtool2 -M -c -a -k -m #{cut_points.inspect.gsub(" ","").gsub("\"","\\\"")} #{master_video_filename}")

    master_video.case_speech_videos.each do |video|
      video.in_processing = true
      video.save
      info "VIDEO TO PROCESS: #{video.title}"
      info "CASE: #{video.case_discussion.meeting_url}"
      speech_video_path = "#{RAILS_ROOT}/public/"+ENV['RAILS_ENV']+"/case_speech_videos/#{video.id}/"
      speech_video_first_tmp_filename = speech_video_path+"speech.tmp_1.flv"
      speech_video_second_tmp_filename = speech_video_path+"speech.tmp_2.flv"
      speech_video_filename = speech_video_path+"speech.flv"
      @shell.execute("mencoder -of lavf -ovc lavc -lavcopts vcodec=flv:vbitrate=400:keyint=230:vqmin=3 -oac copy -ofps 25 -vf \"harddup\"\
       #{speech_video_first_tmp_filename} -o #{speech_video_second_tmp_filename}")
      @shell.execute("flvtool2 -U -c #{speech_video_second_tmp_filename}")
      @shell.execute("rm #{speech_video_first_tmp_filename}")
      @shell.execute("mv #{speech_video_second_tmp_filename} #{speech_video_filename}")
      timepoints = []
      slice_time_sec = video.duration_s/5
      slice_id = 1
      timepoints << [7,video.duration_s-1].min
      3.times do
        timepoints << slice_id*slice_time_sec
        slice_id+=1
      end
      timepoints << [video.duration_s-7,1].max
      pngid=0
      info "Timepoints: #{timepoints.inspect}"
      timepoints.sort.each do |time|
        filename = "thumb_#{pngid+=1}.png"
        if video.title.downcase.index("forseti")
          croptop = 30
          cropbottom = 190
        else
          croptop = 130
          cropbottom = 90
        end
        @shell.execute("ffmpeg -i #{speech_video_filename} -an -croptop #{croptop} -cropbottom #{cropbottom} -cropright 150 -cropleft 238\
           -ss #{[time/3600, time/60 % 60, time % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')} -an -r 1 -vframes 1 -y #{speech_video_path}#{filename}")
        @shell.execute("convert #{speech_video_path}#{filename} -resize 160x99 #{speech_video_path}small_#{filename}")
        @shell.execute("convert #{speech_video_path}#{filename} -resize 80x50 #{speech_video_path}smaller_#{filename}")
        @shell.execute("convert #{speech_video_path}#{filename} -resize 45x28 #{speech_video_path}tiny_#{filename}")
      end
      video.reload :lock=>true
      video.published = 1
      video.in_processing = 0
      video.save
    end
  end
end

video_worker = VideoWorker.new(worker_config)
video_worker.run

#broken CaseDiscussions 5,89