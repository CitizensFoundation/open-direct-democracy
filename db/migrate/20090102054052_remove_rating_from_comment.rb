class RemoveRatingFromComment < ActiveRecord::Migration
  def self.up
    remove_column :document_comments, :rating
  end

  def self.down
  end
end
