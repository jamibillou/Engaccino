class RemoveMainFromEducations < ActiveRecord::Migration
  def up
    remove_column :educations, :main
  end

  def down
    add_column :educations, :main, :boolean
  end
end
