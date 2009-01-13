class VoteRoles < ActiveRecord::Migration
  def self.up
    adminrole = Role.find_by_name("Admin")

    vote_rights_all = Right.create :name => "Vote All",
                                     :controller => "votes",
                                     :action => "*"
    vote_rights_all.save

    vote_proxies_rights_all = Right.create :name => "Vote Proxies All",
                                     :controller => "vote_proxies",
                                     :action => "*"
    vote_proxies_rights_all.save
              
    adminrole.rights << vote_rights_all
    adminrole.rights << vote_proxies_rights_all
    adminrole.save
  end

  def self.down
  end
end
