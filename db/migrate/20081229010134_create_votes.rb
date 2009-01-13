class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :document_id
      t.integer :user_id
      t.boolean :agreed
      t.boolean :frozen

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
