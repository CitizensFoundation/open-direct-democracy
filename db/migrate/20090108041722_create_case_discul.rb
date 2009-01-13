class CreateCaseDiscul < ActiveRecord::Migration
  def self.up
    create_table :case_discussions do |t|
      t.datetime :meeting_date
      t.string :external_id
      t.string :external_url
      t.integer :stage_sequence_number
      t.integer :sequence_number
      t.datetime :to_time
      t.datetime :from_time
      t.string :transcript_url
      t.string :listen_url
      t.string :meeting_info
      t.string :meeting_type
      t.string :meeting_url

      t.timestamps
    end
    
    adminrole = Role.find_by_name("Admin")

    rights_all = Right.create :name => "Case Documents All",
                                     :controller => "case_documents",
                                     :action => "*"
    rights_all.save

    rights_all_1 = Right.create :name => "Case Discussions All",
                                     :controller => "case_discussions",
                                     :action => "*"
    rights_all_1.save

    adminrole.rights << rights_all
    adminrole.rights << rights_all_1
    adminrole.save

  end

  def self.down
    drop_table :case_discussionss
  end
end
