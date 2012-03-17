class RemoveLocationFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :latitude
    remove_column :companies, :longitude
    remove_column :companies, :gmaps
  end

  def down
    add_column :companies, :gmaps, :boolean
    add_column :companies, :longitude, :string
    add_column :companies, :latitude, :string
  end
end
