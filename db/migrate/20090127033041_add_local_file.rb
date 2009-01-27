class AddLocalFile < ActiveRecord::Migration
  def self.up
    add_column :case_speech_master_videos, :local_filename, :string
  end

  def self.down
  end
end
