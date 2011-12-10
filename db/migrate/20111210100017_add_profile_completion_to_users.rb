class AddProfileCompletionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_completion, :integer, :default => 0
  end
end
