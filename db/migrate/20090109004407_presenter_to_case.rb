class PresenterToCase < ActiveRecord::Migration
  def self.up
    add_column :cases, :presenter, :string
    add_column :cases, :external_id, :string
  end

  def self.down
  end
end
