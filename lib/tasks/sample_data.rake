require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_candidates
  end
end
  
def make_candidates
  admin = Candidate.create!(:first_name => "Beau",
                       :last_name => "Gosse",
                       :city => "Barcelona",         
                       :country => "Spain",     
                       :nationality => "Spain",
                       :year_of_birth => 1984,
                       :phone => "+31 6 00000000",
                       :email => "bg@engaccino.com",
                       :facebook_login => "bg@engaccino.com",
                       :linkedin_login => "bg@engaccino.com",
                       :twitter_login => "@beaugosse",
                       :password => "password",
                       :password_confirmation => "password",
                       :status => "open",
                       :profile_completion => 10)
  admin.toggle!(:admin)
  countries = Country.all.collect { |c| c[0] }
  status_array = ['available', 'looking', 'open', 'listening', 'happy']
  years = (1900..12.years.ago.year).to_a
  99.times do |n|
    full_name = Faker::Name.name.split
    email = "user_#{n+1}@engaccino.com"
    twitter = "@#{full_name[0].downcase}_#{full_name[1].downcase.slice(0)}_#{n+1}"
    password = "password"
    country = countries[rand(countries.size)]
    status = status_array[rand(status_array.size)]
    year = years[rand(years.size)]
    Candidate.create!(:first_name => full_name[0],
                 :last_name => full_name[1],
                 :city => "City_#{n+1}",         
                 :country => country,     
                 :nationality => country,
                 :year_of_birth => year,
                 :phone => "+31 6 00000000",
                 :email => email,
                 :facebook_login => email,
                 :linkedin_login => email,
                 :twitter_login => puts(twitter),
                 :password => password,
                 :password_confirmation => password,
                 :status => status,
                 :profile_completion => 10)
  end
end