class CreateCaseTypes < ActiveRecord::Migration
  def self.up
    create_table :case_types do |t|
      t.string :case_type

      t.timestamps
    end
  end

  def self.down
    drop_table :case_types
  end
end
