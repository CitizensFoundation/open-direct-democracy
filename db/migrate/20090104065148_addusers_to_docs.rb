class AddusersToDocs < ActiveRecord::Migration
  def self.up
    add_column :documents, :user_id, :integer
    add_column :document_elements, :user_id, :integer
  end

  def self.down
  end
end
