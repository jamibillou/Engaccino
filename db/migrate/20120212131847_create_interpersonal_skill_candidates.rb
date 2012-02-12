class CreateInterpersonalSkillCandidates < ActiveRecord::Migration
  def change
    create_table :interpersonal_skill_candidates do |t|
      t.string :description
      t.integer :candidate_id
      t.integer :interpersonal_skill_id

      t.timestamps
    end
  end
end
