class ChangeToblob < ActiveRecord::Migration
  def self.up
    remove_column :documents, :legal_text
    add_column :documents, :legal_text, :binary, :limit => 100.megabyte
  end

  def self.down
  end
end
