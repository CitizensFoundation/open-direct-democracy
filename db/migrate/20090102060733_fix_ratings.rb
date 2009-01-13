class FixRatings < ActiveRecord::Migration
  def self.up
    remove_column :ratings, :rateable_type
    add_column :ratings, :rateable_type, :string, :limit => 50, :default => "", :null => false
    ratings_rights_all = Right.find_by_name("Rating All")
    ratings_rights_all.controller = "ratings"
    ratings_rights_all.save
  end

  def self.down
  end
end
