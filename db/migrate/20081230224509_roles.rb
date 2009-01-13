class Roles < ActiveRecord::Migration
  def self.up
    Role.destroy_all
    remove_column :users, :password
    add_column :users, :hashed_password, :string
    add_column :users, :salt, :string
    
    customer_role = Role.create :name => "Customer"
    customer_role.save

    adminrole = Role.create :name => "Admin"

    adminuser = User.create :email => "admin",
            			    :email_confirmation => "admin",
                            :password => "rvb12345",
                            :password_confirmation => "rvb12345",
                            :citizen_id => "0101691234",
                            :citizen_id_confirmation => "0101691234",
                            :password_confirmation => "rvb12345",
                            :first_name => "admin",
			                :last_name => "admin"
    
    adminuser.roles << adminrole
 
    if adminuser.save
      puts "save user complete"
    else
      puts "save user FAILED"
    end

    puts adminuser.to_s

    users_all_rights = Right.create :name => "Users All",
                                     :controller => "users",
                                     :action => "*"
    users_all_rights.save

    home_all_rights = Right.create :name => "Home All",
                                        :controller => "home",
                                        :action => "*"
    home_all_rights.save

    categories_all_rights = Right.create :name => "Categories All",
                                    :controller => "categories",
                                    :action => "*"
    categories_all_rights.save

    documents_all_rights = Right.create :name => "Documents All",
                                     :controller => "documents",
                                     :action => "*"
    documents_all_rights.save

    document_states_all_rights = Right.create :name => "Document States All",
                                     :controller => "document_states",
                                     :action => "*"
    document_states_all_rights.save

    document_types_all_rights = Right.create :name => "Document Types All",
                                     :controller => "document_types",
                                     :action => "*"
    document_types_all_rights.save

              
    adminrole.rights << users_all_rights
    adminrole.rights << home_all_rights
    adminrole.rights << categories_all_rights
    adminrole.rights << documents_all_rights
    adminrole.rights << document_states_all_rights
    adminrole.rights << document_types_all_rights
    adminrole.save

    customer_role.rights << home_all_rights
    
    customer_role.save
  end

  def self.down
  end 
end
