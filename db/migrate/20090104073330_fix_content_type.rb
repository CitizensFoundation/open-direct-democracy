class FixContentType < ActiveRecord::Migration
  def self.up
    remove_column :document_elements, :content_type
    add_column :document_elements, :content_type, :integer
  end

  def self.down
  end
end
