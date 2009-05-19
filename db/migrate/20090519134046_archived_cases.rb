class ArchivedCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :archived, :boolean, :default => false
  end

  def self.down
  end
end
