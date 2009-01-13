class AmendFrozen < ActiveRecord::Migration
  def self.up
    remove_column :votes, :frozen
    add_column :votes, :vote_frozen, :boolean
    remove_column :documents, :frozen
    add_column :documents, :document_frozen, :boolean
  end

  def self.down
  end
end
