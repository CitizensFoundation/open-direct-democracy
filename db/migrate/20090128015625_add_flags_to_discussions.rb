class AddFlagsToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :case_discussions, :in_video_processing, :boolean, :default=>false
    add_column :case_discussions, :video_processing_complete, :boolean, :default=>false
  end

  def self.down
  end
end
