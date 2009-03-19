class AddSecretVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :secret, :boolean, :default=>false
  end

  def self.down
  end
end
