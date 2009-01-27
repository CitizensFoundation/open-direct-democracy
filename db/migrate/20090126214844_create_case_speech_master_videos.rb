class CreateCaseSpeechMasterVideos < ActiveRecord::Migration
  def self.up
    create_table :case_speech_master_videos do |t|
      t.boolean :in_processing
      t.boolean :completed
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :case_speech_master_videos
  end
end
