class AddMissing < ActiveRecord::Migration
  def self.up
    add_column :case_speech_videos, :has_checked_duration, :boolean, :default=>false
  end

  def self.down
  end
end
