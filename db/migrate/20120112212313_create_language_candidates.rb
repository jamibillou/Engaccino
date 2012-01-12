class CreateLanguageCandidates < ActiveRecord::Migration
  def change
    create_table :language_candidates do |t|
      t.integer :language_id
      t.integer :candidate_id
      t.column  :level, :enum, :limit => [:beginner, :intermediate, :fluent, :native]

      t.timestamps
    end
  end
end
