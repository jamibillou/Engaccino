require 'faker'

namespace :db do
  desc "Fill database with an admin user and a couple of standard users"
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
    
    User.create!(
      :first_name => "Bafetimbi",
      :last_name => "Gomis",
      :city => "Lyon",         
      :country => "FR",     
      :nationality => "FR",
      :year_of_birth => 1986,
      :phone => "+33 6 00000000",
      :email => "bafegomis@ol.fr",
      :facebook_login => "bafegomis@example.com",
      :linkedin_login => "bafegomis@example.com",
      :twitter_login => "@bafegomis",
      :password => "BlackPanther",
      :password_confirmation => "BlackPanther")
    
    User.create!(
      :first_name => "Souleymane",
      :last_name => "Camara",
      :city => "Montpellier",         
      :country => "FR",     
      :nationality => "SN",
      :year_of_birth => 1981,
      :phone => "+31 6 00000000",
      :email => "souley@mhsc.com",
      :facebook_login => "souley@example.com",
      :linkedin_login => "souley@example.com",
      :twitter_login => "@souley",
      :password => "Seria@lCrOqueur",
      :password_confirmation => "Seria@lCrOqueur")
      
    User.create!(
      :first_name => "Michael",
      :last_name => "Carrick",
      :city => "Manchester",         
      :country => "GB",     
      :nationality => "GB",
      :year_of_birth => 1978,
      :phone => "+31 6 00000000",
      :email => "mcaaarick@munited.co.uk",
      :facebook_login => "mcaaarick@example.com",
      :linkedin_login => "mcaaarick@example.com",
      :twitter_login => "@mck",
      :password => "Caaaaarick",
      :password_confirmation => "Caaaaarick")
  
  end
end