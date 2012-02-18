class AddMainEducationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :main_education, :integer
  end
end
