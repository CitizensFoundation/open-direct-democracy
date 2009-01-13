class MoreComments < ActiveRecord::Migration
  def self.up
    add_column :document_comments, :bias, :float  
  end

  def self.down
  end
end
