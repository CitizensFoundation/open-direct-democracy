class CaseSpeechMasterVideo < ActiveRecord::Base
  has_many :case_speech_video
  
  has_many :case_speech_videos, 
                          :order => "case_speech_videos.created_at DESC" do
    def get_one_to_process
      find :first, :conditions => "case_speech_videos.published = 0 AND case_speech_videos.in_processing = 0", :lock => true
    end
  end  
end
