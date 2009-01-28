class AddIndexToMasterUrl < ActiveRecord::Migration
  def self.up    
    add_index :case_speech_master_videos, :url, :unique => true
  end

  def self.down
  end
end
