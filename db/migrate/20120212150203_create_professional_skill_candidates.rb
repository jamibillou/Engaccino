class CreateProfessionalSkillCandidates < ActiveRecord::Migration
  def change
    create_table :professional_skill_candidates do |t|
      t.string :level
      t.integer :experience
      t.string :description
      t.integer :candidate_id
      t.integer :professional_skill_id

      t.timestamps
    end
  end
end
