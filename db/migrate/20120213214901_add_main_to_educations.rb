class AddMainToEducations < ActiveRecord::Migration
  def change
    add_column :educations, :main, :boolean, :default => false
  end
end
