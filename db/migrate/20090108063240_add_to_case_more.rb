class AddToCaseMore < ActiveRecord::Migration
  def self.up
    rename_column :documents, :case_documents_id, :case_document_id
  end

  def self.down
  end
end
