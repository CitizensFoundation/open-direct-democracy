class AddCitizenRole < ActiveRecord::Migration
  def self.up
    customer_role = Role.find_by_name "Customer"
    customer_role.destroy

    citizen_role = Role.create :name => "Citizen"
    citizen_role.save
 
    right = Right.create :name => "Cases index",
                                     :controller => "cases",
                                     :action => "index"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Cases show",
                                     :controller => "cases",
                                     :action => "show"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Documents show",
                                     :controller => "documents",
                                     :action => "show"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Document Elements new_change_proposal",
                                     :controller => "document_elements",
                                     :action => "new_change_proposal"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Document Elements create_change_proposal",
                                     :controller => "document_elements",
                                     :action => "create_change_proposal"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Document Elements cancel_new_change_proposal",
                                     :controller => "document_elements",
                                     :action => "cancel_new_change_proposal"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Document Elements view_element",
                                     :controller => "document_elements",
                                     :action => "view_element"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Vote proxies manage_by_proxy_user",
                                     :controller => "vote_proxies",
                                     :action => "manage_by_proxy_user"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Vote proxies manage",
                                     :controller => "vote_proxies",
                                     :action => "manage"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Votes create",
                                     :controller => "votes",
                                     :action => "create"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Votes destroy",
                                     :controller => "votes",
                                     :action => "destroy"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Ratings rate",
                                     :controller => "ratings",
                                     :action => "rate"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "Document Comments create",
                                     :controller => "document_comments",
                                     :action => "create"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "User login",
                                     :controller => "users",
                                     :action => "login"
    right.save
    citizen_role.rights << right

    right = Right.create :name => "User logout",
                                     :controller => "users",
                                     :action => "logout"
    right.save
    citizen_role.rights << right

    admin_role = Role.find_by_name "Admin"
    
    User.find(:all).each do |user|
      unless user.email == "admin"
        user.roles.delete(admin_role)
        user.roles << citizen_role
      end
    end
  end

  def self.down
  end 
end
