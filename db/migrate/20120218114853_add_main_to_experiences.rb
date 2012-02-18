class AddMainToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :main, :boolean, :default => false
  end
end
