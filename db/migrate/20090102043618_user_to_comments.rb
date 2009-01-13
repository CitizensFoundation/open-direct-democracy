class UserToComments < ActiveRecord::Migration
  def self.up
    add_column :document_comments, :user_id, :integer
  end

  def self.down
  end
end
