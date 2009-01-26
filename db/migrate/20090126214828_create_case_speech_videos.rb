class CreateCaseSpeechVideos < ActiveRecord::Migration
  def self.up
    create_table :case_speech_videos do |t|
      t.integer :case_discussion_id
      t.string :title
      t.datetime :to_time
      t.datetime :from_time
      t.integer :sequence_number
      t.integer :parent_id
      t.boolean :in_processing
      t.boolean :published
      t.integer :case_speech_master_video_id

      t.timestamps
    end
    
    add_column :case_discussions, :processed_for_speech_videos, :boolean
    add_column :case_discussions, :published, :boolean
    
    citizen_role = Role.find_by_name("Citizen")
    admin_role = Role.find_by_name("Admin")
 
    right = Right.create :name => "Case Speech Videos all",
                         :controller => "case_speech_videos",
                         :action => "*"
    right.save
    admin_role.rights << right

    right = Right.create :name => "Case Speech Master Videos all",
                         :controller => "case_speech_master_videos",
                         :action => "*"
    right.save
    admin_role.rights << right

    right = Right.create :name => "Case Speech Videos show",
                         :controller => "case_speech_videos",
                         :action => "show"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Case Speech Videos index",
                         :controller => "case_speech_videos",
                         :action => "index"
    right.save
    citizen_role.rights << right
  end

  def self.down
    drop_table :case_speech_videos
  end
end
