class AmendVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :proxy_vote_count, :integer
  end

  def self.down
    remove_column :votes, :proxy_vote_count
  end
end
