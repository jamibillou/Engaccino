class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :degree_id
      t.integer :school_id
      t.integer :candidate_id
      t.string  :description
      t.integer :start_month
      t.integer :start_year
      t.integer :end_month
      t.integer :end_year

      t.timestamps
    end
  end
end
