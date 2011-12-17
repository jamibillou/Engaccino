class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.integer :candidate_id
      t.integer :company_id
      t.integer :start_month
      t.integer :start_year
      t.integer :end_month
      t.integer :end_year
      t.string :description

      t.timestamps
    end
  end
end
