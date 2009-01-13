class CreateVoteProxies < ActiveRecord::Migration
  def self.up
    create_table :vote_proxies do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :category_id
      t.integer :issue_id
      t.integer :document_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vote_proxies
  end
end
