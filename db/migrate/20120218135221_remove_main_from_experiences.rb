class RemoveMainFromExperiences < ActiveRecord::Migration
  def up
    remove_column :experiences, :main
  end

  def down
    add_column :experiences, :main, :boolean
  end
end
