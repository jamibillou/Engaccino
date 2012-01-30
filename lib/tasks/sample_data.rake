require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_candidates
  end
end
  
def make_candidates
  admin = Candidate.create! :first_name            => 'Beau',
                            :last_name             => 'Gosse',
                            :city                  => 'Grenoble',         
                            :country               => 'France',     
                            :nationality           => 'France',
                            :year_of_birth         => 1984,
                            :phone                 => '+33 6 00000000',
                            :email                 => 'bg@engaccino.com',
                            :facebook_login        => 'bg@engaccino.com',
                            :linkedin_login        => 'bg@engaccino.com',
                            :twitter_login         => '@beaugosse',
                            :password              => 'password',
                            :password_confirmation => 'password',
                            :status                => 'open',
                            :profile_completion    => 10
  admin.toggle!(:admin)
  countries    = Country.all.collect { |c| c[0] }
  status_array = ['available', 'looking', 'open', 'listening', 'happy']
  years        = (60.years.ago.year..25.years.ago.year).to_a
  
  99.times do |n|
    full_name  = Faker::Name.name.split
    email      = "user_#{n+1}@engaccino.com"
    password   = 'password'
    country    = countries[rand(countries.size)]
    status     = status_array[rand(status_array.size)]
    year       = years[rand(years.size)]
    @candidate = Candidate.new :first_name            => full_name[0],
                               :last_name             => full_name[1],
                               :city                  => "City #{n+1}",         
                               :country               => country,     
                               :nationality           => country,
                               :year_of_birth         => year,
                               :phone                 => '+00 0 00000000',
                               :email                 => email,
                               :facebook_login        => email,
                               :linkedin_login        => email,
                               :password              => password,
                               :password_confirmation => password,
                               :status                => status,
                               :profile_completion    => 10
    @candidate.save!
    make_educations
    make_experiences
  end
end

def make_educations
  start_yrs    = ((@candidate.year_of_birth + 18)..(@candidate.year_of_birth + 22)).to_a
  start_months = (8..10).to_a
  end_months   = (5..7).to_a
  degrees      = ['Art History', 'Applied Sciences', 'Mathematics', 'Economics', 'Management', 'Foreign Languages', 'History & Geography', 
                  'Philosophy', 'Biology', 'Software Development', 'Mecanics', 'Electronics', 'Physics & Chemistry', 'Medicine']
  degree_types = ["Master's", "Bachelor's", 'Diploma', 'Bachelor degree', 'Master degree', '1 year degree', '2 years degree', '3 years degree', 'P.H.D.']
  loops        = (1..4).to_a
  loops[rand(loops.size)].times do |n|
    education             = Education.new
    education.start_month = start_months[rand(start_months.size)]
    education.start_year  = @candidate.educations.empty? ? start_yrs[rand(start_yrs.size)] : @candidate.last(@candidate.educations).end_year
    education.end_month   = end_months[rand(end_months.size)]
    education_end_years   = ((education.start_year + 1)..(education.start_year + 3)).to_a
    education.end_year    = education_end_years[rand(education_end_years.size)]
    education.candidate   = @candidate
    school                = education.build_school
    school.name           = "University of #{@candidate.city}"
    degree                = education.build_degree
    degree.label          = degrees[rand(degrees.size)]
    degree_type           = degree.build_degree_type
    degree_type.label     = degree_types[rand(degree_types.size)]
    
    [degree_type, degree, school, education, @candidate].each { |object| object.save! }
  end
end

def make_experiences
  start_yrs = (@candidate.last(@candidate.educations).end_year..Time.now.year).to_a
  months    = (1..12).to_a
  positions = ['Sales executive', 'Senior Engineer', 'Junior Technician', 'Teacher', 'Customer Service Clerk', 'Product Manager', 'Hiring Manager', 
               'Retail clerk', 'Owner', 'Founder', 'Chief Executive Officer', 'Chief Financial Officer', 'Junior Buyer', 'Senior Merchandiser']
  loops     = (1..8).to_a
  loops[rand(loops.size)].times do |n|
    experience = Experience.new
    experience.role        = positions[rand(positions.size)]
    experience.start_month = months[rand(months.size)]
    experience.start_year  = @candidate.experiences.empty? ? start_yrs[rand(start_yrs.size)] : @candidate.last(@candidate.experiences).end_year
    experience_end_years   = (experience.start_year..Time.now.year).to_a
    experience.end_year    = experience_end_years[rand(experience_end_years.size)]
    end_months             = experience.start_year == experience.end_year ? ((experience.start_month + 1)..12).to_a : months
    experience.end_month   = end_months[rand(end_months.size)]
    experience.candidate   = @candidate
    company                = experience.build_company
    company.name           = "Company #{@candidate.id}-#{n}"
    
    [company, experience, @candidate].each { |object| object.save! }
  end
end
