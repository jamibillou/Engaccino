class AddDegreesSchoolsTable < ActiveRecord::Migration
  def change
    create_table :degrees_schools, :id => false do |t|
      t.references :degree, :null => false
      t.references :school, :null => false
    end
  end
end
