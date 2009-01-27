class CaseSpeechVideo < ActiveRecord::Base
  acts_as_tree :order=>"from_time"
end
