class AddIdsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :author_id, :integer

    add_column :messages, :recipient_id, :integer

  end
end
