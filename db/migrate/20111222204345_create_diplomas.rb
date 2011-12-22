class CreateDiplomas < ActiveRecord::Migration
  def change
    create_table :diplomas do |t|
      t.string :label

      t.timestamps
    end
  end
end
