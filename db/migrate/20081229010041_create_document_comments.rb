class CreateDocumentComments < ActiveRecord::Migration
  def self.up
    create_table :document_comments do |t|
      t.integer :document_id
      t.text :comment
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :document_comments
  end
end
