class AddArchivesToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :archived_author, :boolean, :default => false
    
    add_column :messages, :archived_recipient, :boolean, :default => false
  
  end
end
