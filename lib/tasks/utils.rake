namespace :utils do
  desc "Backup"
  task(:backup => :environment) do
      filename = "beint.lydraedi.is_#{Time.new.strftime("%d%m%y_%H%M%S")}.sql"
      system("mysqldump -u robert --force --password=zaijei7E odd_master > /tmp/#{filename}")
      system("gzip /tmp/#{filename}")
      system("scp /tmp/#{filename}.gz robert@where.is:backups/#{filename}.gz")
      system("rm /tmp/#{filename}.gz")
  end

  desc "Delete Fully Processed Masters"
  task(:delete_fullly_processed_masters => :environment) do
      masters = CaseSpeechMasterVideo.find(:all)
      masters.each do |master_video|
        puts "master_video id: #{master_video.id} all_done: #{master_video.case_speech_videos.all_done?} has_any_in_processing: #{master_video.case_speech_videos.any_in_processing?}"
        if master_video.case_speech_videos.all_done? and not master_video.case_speech_videos.any_in_processing?
          master_video_flv_filename = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/master.flv"
          if File.exist?(master_video_flv_filename)
            rm_string = "rm #{master_video_flv_filename}"
            puts rm_string
            system(rm_string)
          end
        end
      end
  end

  desc "Exlpore broken videos"
  task(:explore_broken_videos => :environment) do
      masters = CaseSpeechMasterVideo.find(:all)
      masters.each do |master_video|
        unless master_video.case_speech_videos.all_done? and not master_video.case_speech_videos.any_in_processing?
          puts "master_video id: #{master_video.id} all_done: #{master_video.case_speech_videos.all_done?} has_any_in_processing: #{master_video.case_speech_videos.any_in_processing?}"
          master_video_flv_filename = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/master.flv"
          if File.exist?(master_video_flv_filename)
            puts "File exists: #{master_video_flv_filename}"
          else
            puts "File does not: #{master_video_flv_filename}"
          end
          master_video.case_speech_videos.each do |video|
            puts "video id #{video.id} #{video.title} published #{video.published} in_processing #{video.in_processing} duration: #{video.duration_s}"            
          end
          puts " "
        end
      end
  end
end
