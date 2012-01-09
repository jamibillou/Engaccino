class CreateDegreeTypes < ActiveRecord::Migration
  def change
    create_table :degree_types do |t|
      t.string :label

      t.timestamps
    end
  end
end
