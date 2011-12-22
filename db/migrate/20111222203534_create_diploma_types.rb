class CreateDiplomaTypes < ActiveRecord::Migration
  def change
    create_table :diploma_types do |t|
      t.string :label
      t.integer :diploma_id

      t.timestamps
    end
  end
end
