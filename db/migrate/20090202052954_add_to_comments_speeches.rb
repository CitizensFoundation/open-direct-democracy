class AddToCommentsSpeeches < ActiveRecord::Migration
  def self.up
    add_column :document_comments, :case_speech_video_id, :integer
  end

  def self.down
  end
end
