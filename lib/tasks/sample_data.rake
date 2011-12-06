require 'faker'

namespace :db do
  desc "Fill database with an admin user"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(
      :first_name => "Lionel",
      :last_name => "Messi",
      :city => "Barcelona",         
      :country => "ES",     
      :nationality => "ES",
      :year_of_birth => 1984,
      :phone => "+31 6 00000000",
      :email => "l.messi@fcbarcelona.com",
      :facebook_login => "leo.messi@example.com",
      :linkedin_login => "leo.messi@example.com",
      :twitter_login => "@lmessi",
      :password => "99@Pelota",
      :password_confirmation => "99@Pelota")
    
    admin.toggle!(:admin)
  
  end
end