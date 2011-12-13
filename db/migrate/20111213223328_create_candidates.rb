class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :status

      t.timestamps
    end
  end
end
