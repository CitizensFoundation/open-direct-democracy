class CaseSpeechVideo < ActiveRecord::Base
  acts_as_tree :order=>"from_time"
  belongs_to :case_speech_master_video
  belongs_to :case_discussion
end
