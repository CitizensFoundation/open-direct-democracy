class CaseSpeechMasterVideo < ActiveRecord::Base
  has_many :case_speech_video
  
  has_many :case_speech_videos, 
                          :order => "case_speech_videos.created_at DESC" do
    def get_one_to_process
      find :first, :conditions => "case_speech_videos.published = 0 AND case_speech_videos.in_processing = 0 AND case_speech_videos.has_checked_duration = 1", :lock => true
    end

    def all_done?
      a = count :all
      b = count :all, :conditions => "case_speech_videos.published = 1"
      a == b and b!=0
    end

    def get_random_published
      find :first, :conditions => "case_speech_videos.published = 1 AND case_speech_videos.in_processing = 0", :order=>"rand()"
    end
    
    def get_first_published
      find :first, :conditions => "case_speech_videos.published = 1 AND case_speech_videos.in_processing = 0", :order=>"case_speech_videos.start_offset"
    end
  end  
end
