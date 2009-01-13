class AddToCase < ActiveRecord::Migration
  def self.up
    add_column :cases, :info_1, :text
    add_column :cases, :info_2, :text
    add_column :cases, :info_3, :text
    
    add_column :case_documents, :case_id, :integer
    add_column :case_discussions, :case_id, :integer
    rename_column :case_documents, :external_url, :external_link
    rename_column :case_discussions, :external_url, :external_link
  end

  def self.down
  end
end
