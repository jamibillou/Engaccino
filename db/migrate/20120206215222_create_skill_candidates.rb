class CreateSkillCandidates < ActiveRecord::Migration
  def change
    create_table :skill_candidates do |t|
      t.string :level
      t.integer :experience
      t.string :description
      t.integer :candidate_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
