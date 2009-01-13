class TypeFix < ActiveRecord::Migration
  def self.up
    remove_column :document_types, :type
    add_column :document_types, :document_type, :string
  end

  def self.down
  end
end
