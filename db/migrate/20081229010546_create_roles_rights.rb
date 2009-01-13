class CreateRolesRights < ActiveRecord::Migration
  def self.up
    create_table "rights", :force => true do |t|
      t.column "name",       :string
      t.column "controller", :string
      t.column "action",     :string
    end
  
    create_table "rights_roles", :id => false, :force => true do |t|
      t.column "right_id", :integer
      t.column "role_id",  :integer
    end
  
    create_table "roles", :force => true do |t|
      t.column "name", :string
    end
  
    create_table "roles_users", :id => false, :force => true do |t|
      t.column "role_id", :integer
      t.column "user_id", :integer
    end
  end

  def self.down
    drop_table :rights, :rights_roles, :role, :roles_users
  end
end
