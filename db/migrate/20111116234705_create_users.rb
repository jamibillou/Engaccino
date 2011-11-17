class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :city
      t.string :country
      t.string :nationality
      t.date :birthdate
      t.string :phone
      t.string :email
      t.string :facebook_login
      t.string :linkedin_login
      t.string :twitter_login
      t.boolean :facebook_connect, :default => false
      t.boolean :linkedin_connect, :default => false
      t.boolean :twitter_connect, :default => false
      t.boolean :admin, :default => false
      t.string :encrypted_password

      t.timestamps
    end
  end
end
