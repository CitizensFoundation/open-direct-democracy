class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :citizen_id
      t.float :reputation

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
