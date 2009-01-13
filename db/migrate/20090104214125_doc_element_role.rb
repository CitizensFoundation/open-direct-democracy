class DocElementRole < ActiveRecord::Migration
  def self.up
    adminrole = Role.find_by_name("Admin")

    doc_element_rights_all = Right.create :name => "Document Elements All",
                                     :controller => "document_elements",
                                     :action => "*"
    doc_element_rights_all.save
              
    adminrole.rights << doc_element_rights_all
    adminrole.save
  end

  def self.down
  end
end
