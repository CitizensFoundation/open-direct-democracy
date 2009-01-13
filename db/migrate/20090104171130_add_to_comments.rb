class AddToComments < ActiveRecord::Migration
  def self.up
    add_column :document_comments, :document_element_id, :integer
    add_column :document_elements, :original_version, :boolean
  end

  def self.down
  end
end
