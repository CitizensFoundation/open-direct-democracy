class RatingRole < ActiveRecord::Migration
  def self.up
    adminrole = Role.find_by_name("Admin")

    rating_rights_all = Right.create :name => "Rating All",
                                     :controller => "rating",
                                     :action => "*"
    rating_rights_all.save
              
    adminrole.rights << rating_rights_all
    adminrole.save
  end

  def self.down
  end
end
