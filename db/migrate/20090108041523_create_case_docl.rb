class CreateCaseDocl < ActiveRecord::Migration
  def self.up
    create_table :case_documents do |t|
      t.datetime :external_date
      t.string :external_id
      t.string :external_url
      t.integer :stage_sequence_number
      t.integer :sequence_number
      t.string :external_type
      t.string :external_author
      
      t.timestamps
    end
    
    add_column :documents, :case_documents_id, :integer
  end

  def self.down
    drop_table :case_documents
  end
end
