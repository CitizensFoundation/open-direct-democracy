class AddOffset < ActiveRecord::Migration
  def self.up
    add_column :case_speech_videos, :start_offset, :time
    add_column :case_speech_videos, :duration, :time
  end

  def self.down
  end
end
