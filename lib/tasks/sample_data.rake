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
  years = (80.years.ago.year..12.years.ago.year).to_a
  99.times do |n|
    full_name = Faker::Name.name.split
    email = "user_#{n+1}@engaccino.com"
    password = "password"
    country = countries[rand(countries.size)]
    status = status_array[rand(status_array.size)]
    year = years[rand(years.size)]
    @candidate = Candidate.new(:first_name => full_name[0],
                              :last_name => full_name[1],
                              :city => "Sample city",         
                              :country => country,     
                              :nationality => country,
                              :year_of_birth => year,
                              :phone => "+31 6 00000000",
                              :email => email,
                              :facebook_login => email,
                              :linkedin_login => email,
                              :password => password,
                              :password_confirmation => password,
                              :status => status,
                              :profile_completion => 10)
    #make_experiences
    #make_educations
    @candidate.save!    
  end
end

def make_experiences
  experience_start_years = (40.years.ago.year..Time.now.year).to_a
  experience_months = (1..12).to_a
  positions = ['Sales', 'Engineer', 'Technician', 'Teacher', 'Customer service', 'Manager', 'Recruiter', 'Retail', 'Entrepreneur', 'Owner', 'Founder', 'CEO', 'CFO', 'Buyer', 'Merchandiser']
  3.times do |n|
    experience = Experience.new
    experience.role = positions[rand(positions.size)]
    experience.start_month = experience_months[rand(experience_months.size)]
    experience.start_year = experience_start_years[rand(experience_start_years.size)]
    experience.end_month = experience_months[rand(experience_months.size)]
    experience_end_years = (experience.start_year..Time.now.year).to_a
    experience.end_year = experience_end_years[rand(experience_end_years.size)]
    company = Company.new
    company.name = "Sample company"
    company.save!
    experience.company = company
    experience.candidate = @candidate
    experience.save!
    @candidate.experiences.push(experience)
  end
end

def make_educations
  education_start_years = (40.years.ago.year..Time.now.year).to_a
  education_months = (1..12).to_a
  degrees = ['Art', 'Sciences', 'Mathematics', 'Economics', 'Management', 'Sales', 'Retail', 'Languages', 'History', 'Philosophy', 'Biology', 'Software Development', 'Mecanics', 'Electronics', 'Physics']
  degree_types = ["Master's", "Bachelor's", 'Diploma', 'A Levels', 'Local degree']
  3.times do |n|
    education = Education.new
    education.start_month = education_months[rand(education_months.size)]
    education.start_year = education_start_years[rand(education_start_years.size)]
    education.end_month = education_months[rand(education_months.size)]
    education.end_year = education_start_years[rand(education_start_years.size)]
    education.candidate = @candidate
    school = School.new
    school.name = "Sample school"
    school.save!
    degree = Degree.new
    degree.label = degrees[rand(degrees.size)]
    degree_type = DegreeType.new
    degree_type.label = degree_types[rand(degree_types.size)]
    degree_type.save!
    education.school = school
    degree.degree_type = degree_type
    degree.save!
    education.degree = degree
    education.save!
    @candidate.educations.push(education)
  end
end