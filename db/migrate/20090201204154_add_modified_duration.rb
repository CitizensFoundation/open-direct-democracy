class AddModifiedDuration < ActiveRecord::Migration
  def self.up
    add_column :case_speech_videos, :modified_duration_s, :integer
    add_column :case_discussions, :has_modified_durations, :boolean, :default=>false
  end

  def self.down
  end
end
