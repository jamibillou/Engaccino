class AddMainExperienceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :main_experience, :integer
  end
end
