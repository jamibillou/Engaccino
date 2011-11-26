class ChangeBirthdateToYearOfBirth < ActiveRecord::Migration
  def up
    add_column :users, :year_of_birth, :integer
  end

  def down
  end
end
