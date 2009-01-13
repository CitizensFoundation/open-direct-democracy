class CreateCases < ActiveRecord::Migration
  def self.up
    create_table :cases do |t|
      t.string :external_link
      t.string :external_name
      t.integer :case_type_id

      t.timestamps
    end

    add_column :documents, :case_id, :integer
    remove_column :documents, :legal_text
   
    adminrole = Role.find_by_name("Admin")

    cases_rights_all = Right.create :name => "Cases All",
                                     :controller => "cases",
                                     :action => "*"
    cases_rights_all.save
              
    case_types_rights_all = Right.create :name => "Case Types All",
                                     :controller => "case_types",
                                     :action => "*"
    case_types_rights_all.save
              
    adminrole.rights << cases_rights_all
    adminrole.rights << case_types_rights_all
    adminrole.save
  end

  def self.down
    drop_table :cases
  end
end
