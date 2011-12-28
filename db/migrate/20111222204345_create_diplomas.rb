class CreateDegrees < ActiveRecord::Migration
  def change
    create_table :degrees do |t|
      t.string  :label
      t.integer :degree_type_id

      t.timestamps
    end
  end
end
