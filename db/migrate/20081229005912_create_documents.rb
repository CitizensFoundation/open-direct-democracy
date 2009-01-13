class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :category_id
      t.integer :issue_id
      t.integer :document_state_id
      t.integer :document_type_id
      t.text :legal_text
      t.datetime :voting_close_time
      t.boolean :published
      t.boolean :frozen
      t.string :external_name
      t.string :external_author
      t.string :external_state
      t.datetime :external_creation_date
      t.string :external_link

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
