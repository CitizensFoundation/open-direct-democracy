class CreateDocumentStates < ActiveRecord::Migration
  def self.up
    create_table :document_states do |t|
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :document_states
  end
end
