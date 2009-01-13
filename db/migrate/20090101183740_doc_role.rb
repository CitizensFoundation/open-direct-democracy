class DocRole < ActiveRecord::Migration
  def self.up
    adminrole = Role.find_by_name("Admin")

    document_comments_rights = Right.create :name => "Document Comments All",
                                     :controller => "document_comments",
                                     :action => "*"
    document_comments_rights.save
              
    adminrole.rights << document_comments_rights
    adminrole.save
  end

  def self.down
  end
end
