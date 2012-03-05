class AddQuoteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quote, :string
    add_column :users, :company_id, :integer
  end
end
