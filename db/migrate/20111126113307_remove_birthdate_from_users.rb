class RemoveBirthdateFromUsers < ActiveRecord::Migration
  def up
  end

  def down
    remove_column :users, :birthdate
  end
end
