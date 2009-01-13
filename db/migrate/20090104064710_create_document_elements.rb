class CreateDocumentElements < ActiveRecord::Migration
  def self.up
    create_table :document_elements do |t|
      t.integer :sequence_number
      t.integer :document_id
      t.integer :parent_id
      t.string :content_type
      t.binary :content, :limit => 100.megabyte
      t.binary :content_text_only, :limit => 100.megabyte
      t.string :content_number

      t.timestamps
    end
  end

  def self.down
    drop_table :document_elements
  end
end
