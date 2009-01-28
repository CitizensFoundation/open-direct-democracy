class CaseSpeechVideo < ActiveRecord::Base
  acts_as_tree :order=>"from_time"
  belongs_to :case_speech_master_video
  belongs_to :case_discussion
  
  def get_image_tag(padding_direction="top", image_size="tiny")
    speech_video_path = "/"+ENV['RAILS_ENV']+"/case_speech_videos/#{self.id}/"
    tiny_filename = "#{speech_video_path}#{image_size}_thumb_2.png"
    ancenstor_number = self.ancestors.length
    "<a href=\"/case_speech_videos/show/#{self.id}\"><img src=\"#{tiny_filename}\" border=0 style=\"padding-#{padding_direction}:#{ancenstor_number*7}px\"></a>"
  end

  def get_video_link_tag
    speech_video_path = "/"+ENV['RAILS_ENV']+"/case_speech_videos/#{self.id}/"
    "#{speech_video_path}speech.flv"
  end

end
