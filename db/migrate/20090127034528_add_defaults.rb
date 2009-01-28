class AddDefaults < ActiveRecord::Migration
  def self.up
    remove_column :case_speech_videos, :in_processing
    remove_column :case_speech_videos, :published
    add_column :case_speech_videos, :in_processing, :boolean, :default=>false
    add_column :case_speech_videos, :published, :boolean, :default=>false
    
    remove_column :case_speech_master_videos, :in_processing
    remove_column :case_speech_master_videos, :completed
    add_column :case_speech_master_videos, :in_processing, :boolean, :default=>false
    add_column :case_speech_master_videos, :published, :boolean, :default=>false
  end

  def self.down
  end
end
