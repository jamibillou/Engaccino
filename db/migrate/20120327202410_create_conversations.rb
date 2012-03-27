class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :candidate_id
      t.integer :recruiter_id

      t.timestamps
    end
  end
end
