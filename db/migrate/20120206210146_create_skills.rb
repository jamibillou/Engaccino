class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :label
      t.string :type

      t.timestamps
    end
  end
end
