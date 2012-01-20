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
  years = (70.years.ago.year..16.years.ago.year).to_a
  phone_digits = (0..9).to_a
  99.times do |n|
    full_name = Faker::Name.name.split
    email = "user_#{n+1}@engaccino.com"
    password = "password"
    country = countries[rand(countries.size)]
    status = status_array[rand(status_array.size)]
    year = years[rand(years.size)]
    @candidate = Candidate.new  :first_name => full_name[0],
                                :last_name => full_name[1],
                                :city => "Sample city",         
                                :country => country,     
                                :nationality => country,
                                :year_of_birth => year,
                                :phone => "+00 0 00000000",
                                :email => email,
                                :facebook_login => email,
                                :linkedin_login => email,
                                :password => password,
                                :password_confirmation => password,
                                :status => status,
                                :profile_completion => 10
    @candidate.save!
    make_educations
    make_experiences
  end
end

def make_educations
  education_start_years = (@candidate.year_of_birth..Time.now.year).to_a
  education_start_months = (8..10).to_a
  education_end_months = (5..7).to_a
  degrees = ['Art', 'Sciences', 'Mathematics', 'Economics', 'Management', 'Languages', 'History', 'Philosophy', 'Biology', 'Software Development', 'Mecanics', 'Electronics', 'Physics']
  degree_types = ["Master's", "Bachelor's", 'Diploma']
  3.times do |n|
    education = Education.new
    education.start_month = education_start_months[rand(education_start_months.size)]
    education.start_year  = education_start_years[rand(education_start_years.size)]
    education.end_month   = education_end_months[rand(education_end_months.size)]
    education_end_years = (education.start_year..Time.now.year).to_a
    education.end_year  = education_end_years[rand(education_end_years.size)]
    education.candidate = @candidate
    school = education.build_school
    school.name = "Sample school"
    degree = education.build_degree
    degree.label = degrees[rand(degrees.size)]
    degree_type  = degree.build_degree_type
    degree_type.label = degree_types[rand(degree_types.size)]
    degree_type.save!
    degree.save!
    school.save!
    education.save!
    @candidate.save!
  end
end

def make_experiences
  experience_start_years = (@candidate.year_of_birth..Time.now.year).to_a
  experience_months = (1..12).to_a
  positions = ['Sales', 'Engineer', 'Technician', 'Teacher', 'Customer service', 'Manager', 'Recruiter', 'Retail', 'Entrepreneur', 'Owner', 'Founder', 'CEO', 'CFO', 'Buyer', 'Merchandiser']
  3.times do |n|
    experience = Experience.new :role        => positions[rand(positions.size)],
                                :start_month => experience_months[rand(experience_months.size)],
                                :start_year  => experience_start_years[rand(experience_start_years.size)],
                                :end_month   => experience_months[rand(experience_months.size)]
    experience_end_years = (experience.start_year..Time.now.year).to_a
    experience.end_year  = experience_end_years[rand(experience_end_years.size)]
    experience.candidate = @candidate
    company = experience.build_company
    company.name = "Sample company"
    company.save!
    experience.save!
    @candidate.save!
  end
end
