class AddOriginalVersion < ActiveRecord::Migration
  def self.up
    add_column :documents, :original_version, :boolean
  end

  def self.down
  end
end
