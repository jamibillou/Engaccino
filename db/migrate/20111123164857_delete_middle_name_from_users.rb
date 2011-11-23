class DeleteMiddleNameFromUsers < ActiveRecord::Migration
  def up
  end

  def down
    remove_column :users, :middle_name
  end
end
