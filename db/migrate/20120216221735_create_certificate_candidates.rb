class CreateCertificateCandidates < ActiveRecord::Migration
  def change
    create_table :certificate_candidates do |t|
      t.string :level_score
      t.integer :candidate_id
      t.integer :certificate_id

      t.timestamps
    end
  end
end
