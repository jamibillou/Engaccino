class AddRoleToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :role, :string
  end
end
