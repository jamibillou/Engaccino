class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :degree_id
      t.integer :school_id
      t.integer :candidate_id
      t.string  :description
      t.integer :year

      t.timestamps
    end
  end
end
