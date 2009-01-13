class ChangeExternalIdType < ActiveRecord::Migration
  def self.up
    remove_column :cases, :external_id
    add_column :cases, :external_id, :integer
  end

  def self.down
  end
end
