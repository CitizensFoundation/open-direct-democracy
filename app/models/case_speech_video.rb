class CaseSpeechVideo < ActiveRecord::Base
  acts_as_tree :order=>"from_time"
  belongs_to :case_speech_master_video
  belongs_to :case_discussion
  
  acts_as_rateable  

  def has_comments?
    DocumentComment.find(:first, :conditions => ["case_speech_video_id = ?", self.id])
  end
  
  def comments_against
    DocumentComment.find(:all, :conditions => ["case_speech_video_id = ? and bias < 0", self.id])
  end
  
  def comments_not_sure
    DocumentComment.find(:all, :conditions => ["case_speech_video_id = ? and bias = 0", self.id])
  end
  
  def comments_in_support
    DocumentComment.find(:all, :conditions => ["case_speech_video_id = ? and bias > 0", self.id])
  end
  
  def get_image_tag(padding_direction="top", image_size="tiny")
    speech_video_path = "/"+ENV['RAILS_ENV']+"/case_speech_videos/#{self.id}/"
    tiny_filename = "#{speech_video_path}#{image_size}_thumb_#{rand(5-2)+2}.png"
    ancenstor_number = self.ancestors.length
    "<a href=\"/case_speech_videos/show/#{self.id}\"><img src=\"#{tiny_filename}\" border=0 style=\"padding-#{padding_direction}:#{ancenstor_number*7}px\"></a>"
  end

  def get_video_link_tag
    speech_video_path = "/"+ENV['RAILS_ENV']+"/case_speech_videos/#{self.id}/"
    "#{speech_video_path}speech.flv"
  end
  
  def get_playlist_image_url(image_size="tiny")
    speech_video_path = "/"+ENV['RAILS_ENV']+"/case_speech_videos/#{self.id}/"
    "#{speech_video_path}#{image_size}_thumb_#{rand(5-2)+2}.png"
  end

  def inpoint_s
    time_to_seconds(self.start_offset)
  end

  def duration_s
    time_to_seconds(self.duration)
  end

  def outpoint_s
    inpoint_s+duration_s
  end

  def modified_outpoint_s
    inpoint_s+self.modified_duration_s
  end

  def set_modified_duration_from_end_time(new_end_time)
    self.modified_duration_s = time_to_seconds(new_end_time)-inpoint_s
  end

  def modified_duration_long
    if self.modified_duration_s
      time = self.modified_duration_s
    else
      time = duration_s
    end
    seconds    =  time % 60
    time = (time - seconds) / 60
    minutes    =  time % 60
    time = (time - minutes) / 60
    hours      =  time % 24
    if hours > 0
      "#{hours} kl #{minutes} mín #{seconds} sek"
    elsif minutes > 0
      "#{minutes} mín #{seconds} sek"
    else
      "#{seconds} sek"
    end
  end
  
  def video_share_screenshot_image
    speech_video_path = "/"+ENV['RAILS_ENV']+"/case_speech_videos/#{self.id}/"
    "#{speech_video_path}thumb_#{rand(5-2)+2}.png"
  end

  def video_share_url
    "/"+ENV['RAILS_ENV']+"/case_speech_videos/#{self.id}/speech.flv"
  end

  def video_share_width
    "640"
  end

  def video_share_height
    "376"
  end

  def video_content_type
    "application/x-shockwave-flash"
  end

  private

  def time_to_seconds(time)
    (time.strftime("%H").to_i*60*60) +
    (time.strftime("%M").to_i*60) +
    (time.strftime("%S").to_i)
  end
end
