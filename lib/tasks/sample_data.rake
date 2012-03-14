# encoding: UTF-8
require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_candidates
    make_recruiters
  end
end
  
def make_candidates
  make_dominic_candidate
  make_franck_candidate
  99.times do |n|
    make_candidate
  end
end

def make_recruiters
  @engaccino = Company.create! :name => 'Engaccino', :url => 'www.engaccino.com', :city => 'Rotterdam', :country => 'Netherlands'
  make_dominic_recruiter
  make_franck_recruiter
  99.times do |n|
    make_recruiter
  end
end

def make_candidate
  ages       = (55.years.ago.year..25.years.ago.year).to_a
  full_name  = Faker::Name.name.split
  email      = "#{full_name[0].sub(' ', '').sub('.','').sub("'",'').downcase}.#{full_name[1].sub(' ', '').sub('.','').sub("'",'').downcase}@gmail.com"
  password   = 'password'
  @candidate = Candidate.new :first_name     => full_name[0],                            :last_name             => full_name[1],
                             :city           => @dutch_cities[rand(@dutch_cities.size)], :country               => 'Netherlands',     
                             :nationality    => 'Netherlands',                           :year_of_birth         => ages[rand(ages.size)],
                             :phone          => '+31 0 00000000',                        :email                 => email,
                             :facebook_login => email,                                   :linkedin_login        => email,
                             :password       => password,                                :password_confirmation => password,
                             :status         => @status_array[rand(@status_array.size)]
  @candidate.save!
  make_educations
  make_experiences
  make_professional_skills
  make_interpersonal_skills
  make_languages
  @candidate.update_attributes :profile_completion => 95, :main_experience => @candidate.last_experience.id, :main_education => @candidate.last_education.id
end

def make_educations
  start_yrs = ((@candidate.year_of_birth + 17)..(@candidate.year_of_birth + 19)).to_a
  start_months = (8..10).to_a
  end_months   = (5..7).to_a
  loops = (1..3).to_a
  loops[rand(loops.size)].times do |n|
    start_month = start_months[rand(start_months.size)]
    start_year  = @candidate.educations(true).empty? ? start_yrs[rand(start_yrs.size)] : @candidate.last_education.end_year
    end_yrs     = ((start_year + 1 < Time.now.year ? start_year + 1 : Time.now.year)..(start_year + 2 < Time.now.year ? start_year + 2 : Time.now.year)).to_a
    end_year    = end_yrs[rand(end_yrs.size)]
    end_months  = start_month < 11 ? ((start_month + 1)..12).to_a : [12] if start_year == end_year
    end_month   = end_months[rand(end_months.size)]
    education   = Education.new(:start_month => start_month, :start_year => start_year, :end_month => end_month, :end_year => end_year, :description => @descriptions[rand(@descriptions.size)][0..298])
    education.candidate   = @candidate
    school                = education.build_school(:name => "University of #{@candidate.city}")
    degree                = education.build_degree(:label => @degrees[rand(@degrees.size)])
    degree_type           = degree.build_degree_type(:label => @degree_types[rand(@degree_types.size)])
    [degree_type, degree, school, education, @candidate].each { |object| object.save! }
  end
end

def make_experiences
  start_yrs     = (@candidate.last_education.end_year..(@candidate.last_education.end_year+1 <= Time.now.year ? @candidate.last_education.end_year+1 : Time.now.year)).to_a
  start_months  = (1..12).to_a
  end_months    = (1..12).to_a
  loops = (1..5).to_a
  loops[rand(loops.size)].times do |n|
    start_month = start_months[rand(start_months.size)]
    unless @candidate.nil? || @candidate.experiences(true).empty?
      start_yrs = (@candidate.last_experience.end_year..(@candidate.last_experience.end_year+2 <= Time.now.year ? @candidate.last_experience.end_year+2 : Time.now.year)).to_a
    end
    start_year  = start_yrs[rand(start_yrs.size)]
    end_years   = ((start_year+1 < Time.now.year ? start_year+1 : Time.now.year)..(start_year+10 < Time.now.year ? start_year+10 : Time.now.year)).to_a
    end_year    = end_years[rand(end_years.size)]
    end_months  = start_month < 11 ? ((start_month + 1)..12).to_a : [12] if start_year == end_year
    end_month   = end_months[rand(end_months.size)]
    experience             = Experience.new(:start_month => start_month, :start_year => start_year, :end_month => end_month, :end_year => end_year,
                                            :role => @positions[rand(@positions.size)], :description => @descriptions[rand(@descriptions.size)][0..298])
    experience.candidate   = @candidate
    company                = experience.build_company(:name => @companies[rand(@companies.size)])
    [company, experience, @candidate].each { |object| object.save! }
  end
end
  
def make_professional_skills
  loops = (2..4).to_a
  loops[rand(loops.size)].times do |n|
    professional_skill                                 = ProfessionalSkill.new(:label => @professional_skills_labels[rand(@professional_skills_labels.size)])
    professional_skill_candidate                       = ProfessionalSkillCandidate.new(:level => @levels[rand(@levels.size)], :experience => @experiences[rand(@experiences.size)], :description => @descriptions[rand(@descriptions.size)][0..158])
    professional_skill_candidate.professional_skill    = professional_skill
    professional_skill_candidate.candidate             = @candidate
    professional_skill_candidate.save!
  end
end
  
def make_interpersonal_skills
  loops = (2..4).to_a
  loops[rand(loops.size)].times do |n|
    interpersonal_skill                       = InterpersonalSkill.new(:label => @interpersonal_skills_labels[rand(@interpersonal_skills_labels.size)])
    interpersonal_skill_candidate             = InterpersonalSkillCandidate.new(:description => @descriptions[rand(@descriptions.size)][0..158])
    interpersonal_skill_candidate.interpersonal_skill       = interpersonal_skill
    interpersonal_skill_candidate.candidate   = @candidate
    interpersonal_skill_candidate.save!
  end
end

def make_languages
  loops = (0..3).to_a
  loops[rand(loops.size)].times do |n|
    language            = Language.new(:label => @languages[rand(@languages.size)])
    language_candidate  = LanguageCandidate.new(:level => @language_levels[rand(@language_levels.size)])
    language_candidate.language = language
    language_candidate.candidate = @candidate
    language_candidate.save!
  end
end

def make_certificates
  loops = (0..5).to_a
  loops[rand(loops.size)].times do |n|
    certificate = Certificate.new(:label => @certificates[rand(@certificates.size)])
    certificate_candidate = CertificateCandidate.new(:level_score => rand((0..1000).to_s))
    certificate_candidate
  end
end

def make_dominic_candidate
  dominic = Candidate.create! :first_name     => 'Dominic',               :last_name          => 'Matheron',
                              :city           => 'Rotterdam',             :country            => 'Netherlands',     
                              :nationality    => 'France',                :year_of_birth      => 1984,
                              :phone          => '+31 6 31912261',        :email              => 'dcandidate@ccino.com',
                              :facebook_login => 'dcandidate@ccino.com',  :linkedin_login     => 'dcandidate@ccino.com',
                              :twitter_login  => '@dcandidate',            :password           => 'password', :password_confirmation => 'password',
                              :status         => 'open'
  dominic.toggle!(:admin)
  ltb           = { :role => 'Customer Service Rep.', :company => 'LTB Jeans',             :start_month => 9, :start_year => 2011, :end_month => 2,  :end_year => 2012 }
  tm            = { :role => 'Branch Manager',        :company => 'Transport Marketplace', :start_month => 6, :start_year => 2010, :end_month => 6,  :end_year => 2011 }
  gift_factory  = { :role => 'Export Sales Rep.',     :company => 'GiftFactory',           :start_month => 5, :start_year => 2009, :end_month => 8,  :end_year => 2009 }
  databox       = { :role => 'Sales Rep.',            :company => 'Databox',               :start_month => 1, :start_year => 2009, :end_month => 5,  :end_year => 2009 }
  experiences   = [ ltb, tm, gift_factory, databox ]
  master        = { :degree_type => "Master's degree",         :label => 'International Business & Relations', :school => 'University of Lille and Savoy',
                    :start_month => 9, :start_year => 2007,    :end_month => 9,  :end_year => 2009 }
  licence       = { :degree_type => "Bachelor's degree",       :label => 'Multimedia',                         :school => 'University of Franch-Comte',          
                    :start_month => 9, :start_year => 2006,    :end_month => 6,  :end_year => 2007 }
  bachelor      = { :degree_type => 'Bachelor of Arts (Hons)', :label => 'International Trade',                :school => 'University of Wolverhampton',          
                    :start_month => 9, :start_year => 2005,    :end_month => 6,  :end_year => 2006 }                 
  dut           = { :degree_type => '2 years degree',          :label => 'Software Development',               :school => 'University Pierre Mendes-France ',
                    :start_month => 9, :start_year => 2003,    :end_month => 6,  :end_year => 2005 }
  educations = [ master, licence, bachelor, dut ]
  professional_skills  = [ { :label => 'Software Development', :exp => 1, :level => 'intermediate' },
                           { :label => 'Sales',                :exp => 2, :level => 'advanced' },
                           { :label => 'Customer service',     :exp => 1, :level => 'beginner' } ]
  interpersonal_skills = [ 'Patience', 'Attention to details', 'Communication skills', 'Enthusiasm' ]
  languages = [ { :label => 'French',  :level => 'native' }, { :label => 'English', :level => 'fluent' } ]
  certificates = [ { :label => 'Driving licence', :level_score => '' } ]
  experiences.each do |exp|
    experience           = Experience.new(:role => exp[:role], :start_month => exp[:start_month], :start_year => exp[:start_year], :end_month => exp[:end_month],  :end_year => exp[:end_year],
                                          :description => @descriptions[rand(@descriptions.size)][0..298])
    experience.candidate = dominic
    company              = experience.build_company(:name => exp[:company])
    [company, experience, dominic].each { |object| object.save! }
  end
  educations.each do |edu|
    education = Education.new(:start_month => edu[:start_month], :start_year => edu[:start_year], :end_month => edu[:end_month],  :end_year => edu[:end_year],
                              :description => @descriptions[rand(@descriptions.size)][0..298])
    education.candidate = dominic
    school              = education.build_school(:name => edu[:school])
    degree              = education.build_degree(:label => edu[:label])
    degree_type         = degree.build_degree_type(:label => edu[:degree_type])
    [degree_type, degree, school, education, dominic].each { |object| object.save! }
  end
  professional_skills.each do |pro_skill|
    professional_skill                                = ProfessionalSkill.new(:label => pro_skill[:label])
    professional_skill_candidate                      = ProfessionalSkillCandidate.new(:level =>  pro_skill[:level], :experience => pro_skill[:exp], :description => @descriptions[rand(@descriptions.size)][0..158])
    professional_skill_candidate.candidate            = dominic
    professional_skill_candidate.professional_skill   = professional_skill
    professional_skill_candidate.save!
  end
  interpersonal_skills.each_with_index do |perso_skill, index|
    interpersonal_skill                                 = InterpersonalSkill.new(:label => interpersonal_skills[index])
    interpersonal_skill_candidate                       = InterpersonalSkillCandidate.new(:description => @descriptions[rand(@descriptions.size)][0..158])
    interpersonal_skill_candidate.candidate             = dominic
    interpersonal_skill_candidate.interpersonal_skill   = interpersonal_skill
    interpersonal_skill_candidate.save!
  end
  languages.each do |language|
    language_candidate            = LanguageCandidate.new(:level => language[:level])
    language                      = Language.new(:label => language[:label])
    language_candidate.candidate  = dominic
    language_candidate.language   = language
    language_candidate.save!
  end
  certificates.each do |certificate|
    certificate_candidate = CertificateCandidate.new(:level_score => certificate[:level_score])
    certificate = Certificate.new(:label => certificate[:label])
    certificate_candidate.candidate = dominic
    certificate_candidate.certificate = certificate
    certificate_candidate.save!
  end
  dominic.update_attributes :profile_completion => 95, :main_experience => dominic.last_experience.id, :main_education => dominic.last_education.id
end

def make_franck_candidate
  franck = Candidate.create! :first_name     => 'Franck',               :last_name          => 'Sabattier',
                             :city           => 'Grenoble',             :country            => 'France',     
                             :nationality    => 'France',               :year_of_birth      => 1985,
                             :phone          => '+33 6 66393633',       :email              => 'fcandidate@ccino.com',
                             :facebook_login => 'fcandidate@ccino.com', :linkedin_login     => 'fcandidate@ccino.com',
                             :twitter_login  => '@fcandidate',          :password           => 'password', :password_confirmation => 'password',
                             :status         => 'open'
  franck.toggle!(:admin)
  px2      = { :role => 'IT Engineer',                :company => 'PX Therapeutics',        :start_month => 11, :start_year => 2010, :end_month => 2,  :end_year => 2012 }
  london   = { :role => 'IT/Bioinformatics Engineer', :company => 'University of Perugia',  :start_month => 4,  :start_year => 2010, :end_month => 10, :end_year => 2010}
  px1      = { :role => 'IT Engineer',                :company => 'PX Therapeutics',        :start_month => 4,  :start_year => 2009, :end_month => 3,  :end_year => 2010 }
  acensi   = { :role => 'IT Engineer',                :company => 'Acensi Innovation',      :start_month => 9,  :start_year => 2008, :end_month => 3,  :end_year => 2009 }
  logica   = { :role => 'IT Engineer Internal',       :company => 'Logica',                 :start_month => 3,  :start_year => 2008, :end_month => 8,  :end_year => 2008 }
  experiences = [ logica, acensi, px1, london, px2 ]
  
  polyfarce = { :degree_type => 'Engineer',         :label => 'Génie des Logiciels et Services',              :school => "Polytech'Savoie",
                :start_month => 9, :start_year => 2005,    :end_month => 6,  :end_year => 2008 }
  iut       = { :degree_type => 'IUT',              :label => 'Informatique option génie informatique',       :school => 'UPMF Grenoble',
                :start_month => 9, :start_year => 2003,    :end_month => 6,  :end_year => 2005 }
  bac       = { :degree_type => 'Baccalauréat',     :label => "Scientifique, option sciences de l'ingénieur", :school => 'Lycée Louis Armand',
                :start_month => 9, :start_year => 2000,    :end_month => 6,  :end_year => 2003 }
  educations = [ bac, iut, polyfarce ]
  professional_skills  = [ { :label => 'Software Development', :exp => 3, :level => 'advanced' },
                           { :label => 'User Training',        :exp => 2, :level => 'intermediate' },
                           { :label => 'Bioinformatics',       :exp => 1, :level => 'beginner' } ]
  interpersonal_skills = [ 'Patience', 'Open Minded', 'Autonomy', 'Self Confidence' ]
  languages = [ { :label => 'French',  :level => 'native' }, 
                { :label => 'English', :level => 'intermediate' },  
                { :label => 'Spanish', :level => 'beginner' } ]
  certificates = [ { :label => 'TOEIC', :level_score => '790' },
                   { :label => 'Driving licence', :level_score => 'Success' } ]
  experiences.each do |exp|
    experience           = Experience.new(:role => exp[:role], :start_month => exp[:start_month], :start_year => exp[:start_year], :end_month => exp[:end_month],  :end_year => exp[:end_year],
                                          :description => @descriptions[rand(@descriptions.size)][0..298])
    experience.candidate = franck
    company              = experience.build_company(:name => exp[:company])
    [company, experience, franck].each { |object| object.save! }
  end
  educations.each do |edu|
    education = Education.new(:start_month => edu[:start_month], :start_year => edu[:start_year], :end_month => edu[:end_month],  :end_year => edu[:end_year],
                              :description => @descriptions[rand(@descriptions.size)][0..298])
    education.candidate = franck
    school              = education.build_school(:name => edu[:school])
    degree              = education.build_degree(:label => edu[:label])
    degree_type         = degree.build_degree_type(:label => edu[:degree_type])
    [degree_type, degree, school, education, franck].each { |object| object.save! }
  end
  professional_skills.each do |pro_skill|
    professional_skill                                = ProfessionalSkill.new(:label => pro_skill[:label])
    professional_skill_candidate                      = ProfessionalSkillCandidate.new(:level =>  pro_skill[:level], :experience => pro_skill[:exp], :description => @descriptions[rand(@descriptions.size)][0..158])
    professional_skill_candidate.candidate            = franck
    professional_skill_candidate.professional_skill   = professional_skill
    professional_skill_candidate.save!
  end
  interpersonal_skills.each_with_index do |perso_skill, index|
    interpersonal_skill                                 = InterpersonalSkill.new(:label => interpersonal_skills[index])
    interpersonal_skill_candidate                       = InterpersonalSkillCandidate.new(:description => @descriptions[rand(@descriptions.size)][0..158])
    interpersonal_skill_candidate.candidate             = franck
    interpersonal_skill_candidate.interpersonal_skill   = interpersonal_skill
    interpersonal_skill_candidate.save!
  end
  languages.each do |language|
    language_candidate            = LanguageCandidate.new(:level => language[:level])
    language                      = Language.new(:label => language[:label])
    language_candidate.candidate  = franck
    language_candidate.language   = language
    language_candidate.save!
  end
  certificates.each do |certificate|
    certificate_candidate = CertificateCandidate.new(:level_score => certificate[:level_score])
    certificate = Certificate.new(:label => certificate[:label])
    certificate_candidate.candidate = franck
    certificate_candidate.certificate = certificate
    certificate_candidate.save!
  end
  franck.update_attributes :profile_completion => 95, :main_experience => franck.last_experience.id, :main_education => franck.last_education.id
end

def make_recruiter
  ages       = (55.years.ago.year..35.years.ago.year).to_a
  full_name  = Faker::Name.name.split
  email      = "#{full_name[0].sub(' ', '').sub('.','').sub("'",'').downcase}.#{full_name[1].sub(' ', '').sub('.','').sub("'",'').downcase}@gmail.com"
  password   = 'password'
  @recruiter = Recruiter.new :first_name     => full_name[0],                            :last_name             => full_name[1],
                             :city           => @dutch_cities[rand(@dutch_cities.size)], :country               => 'Netherlands',     
                             :nationality    => 'Netherlands',                           :year_of_birth         => ages[rand(ages.size)],
                             :phone          => '+31 0 00000000',                        :email                 => email,
                             :facebook_login => email,                                   :linkedin_login        => email,
                             :password       => password,                                :password_confirmation => password,
                             :quote          => @descriptions[rand(@descriptions.size)][0..199]
  @company = Company.find(Company.all.map { |company| company.id }[rand(Company.all.count)])
  @company.update_attributes :url => "www.#{@company.name.gsub(' ','').downcase}.nl", :city => @dutch_cities[rand(@dutch_cities.size)], :country => 'Netherlands'
  @recruiter.company = @company
  @recruiter.save!
  @recruiter.update_attributes :profile_completion => 95
end

def make_dominic_recruiter
  dominic = Recruiter.new :first_name     => 'Dominic',               :last_name          => 'Matheron',
                          :city           => 'Rotterdam',             :country            => 'Netherlands',     
                          :nationality    => 'France',                :year_of_birth      => 1984,
                          :phone          => '+31 6 31912261',        :email              => 'drecruiter@ccino.com',
                          :facebook_login => 'drecruiter@ccino.com',  :linkedin_login     => 'drecruiter@ccino.com',
                          :twitter_login  => '@drecruiter',           :password           => 'password', :password_confirmation => 'password',
                          :quote          => 'As co-founder of Engaccino, I commit to helping you get and stay in touch with potential employers. I also am a hobbyist recruiter and happen to know a lot of great companies.'
  dominic.admin = true ; dominic.company = @engaccino ; dominic.profile_completion = 95 ; dominic.save!
end

def make_franck_recruiter
  franck = Recruiter.new :first_name     => 'Franck',               :last_name          => 'Sabattier',
                         :city           => 'Grenoble',             :country            => 'France',     
                         :nationality    => 'France',               :year_of_birth      => 1985,
                         :phone          => '+33 6 66393633',       :email              => 'frecruiter@ccino.com',
                         :facebook_login => 'frecruiter@ccino.com', :linkedin_login     => 'frecruiter@ccino.com',
                         :twitter_login  => '@frecruiter',          :password           => 'password', :password_confirmation => 'password',
                         :quote          => 'As co-founder of Engaccino, I commit to helping you get and stay in touch with potential employers. I also am a hobbyist recruiter and happen to know a lot of great companies.'
  franck.admin = true ; franck.company = @engaccino ; franck.profile_completion = 95 ; franck.save!
end

@dutch_cities = [ 'Almere', 'Lelystad', 'Bolsward', 'Dokkum', 'Drachten', 'Franeker', 'Harlingen', 'Heerenveen', 'Hindeloopen', 'IJlst', 'Leeuwarden', 'Sloten', 'Sneek', 'Stavoren', 'Workum', 'Apeldoorn', 'Arnhem', 'Bredevoort', 'Buren', 'Culemborg', 'Dieren', 'Doetinchem', 'Ede', 'Groenlo', 'Harderwijk', 'Hattem', 'Huissen', 'Nijkerk', 'Nijmegen', 'Tiel', 'Wageningen', 'Wijchen', 'Winterswijk', 'Zaltbommel', 'Zutphen', 'Deil', 'Enspijk', 'Appingedam', 'Delfzijl', 'Groningen', 'Hoogezand-Sappemeer', 'Stadskanaal', 'Winschoten', 'Veendam', 'Geleen', 'Gennep', 'Heerlen', 'Kerkrade', 'Kessel', 'Landgraaf', 'Maastricht', 'Montfort', 'Nieuwstadt', 'Roermond', 'Sittard', 'Schin op Geul', 'Stein', 'Thorn', 'Valkenburg aan de Geul', 'Venlo', 'Weert', 'Bergen op Zoom', 'Breda', 'Den Bosch', 'Eindhoven', 'Geertruidenberg', 'Grave', 'Helmond', 'Heusden', 'Klundert', 'Oosterhout', 'Oss', 'Ravenstein', 'Roosendaal', 'Tilburg', 'Waalwijk', 'Willemstad', 'Woudrichem', 'Alkmaar', 'Amstelveen', 'Amsterdam', 'Den Helder', 'Edam, Volendam', 'Enkhuizen', 'Haarlem', 'Heerhugowaard', 'Hilversum', 'Hoofddorp', 'Hoorn', 'Laren', 'Purmerend', 'Medemblik', 'Monnickendam', 'Muiden', 'Naarden', 'Schagen', 'Weesp', 'Zaanstad', 'Almelo', 'Blokzijl', 'Deventer', 'Enschede', 'Genemuiden', 'Hasselt', 'Hengelo', 'Kampen', 'Oldenzaal', 'Steenwijk', 'Vollenhove', 'Zwolle', 'Alphen aan den Rijn', 'Delft', 'Dordrecht', 'Gorinchem', 'Gouda', 'Leiden', 'Rotterdam', 'Spijkenisse', 'Den Haag', 'Zoetermeer', 'Amersfoort', 'Houten', 'Leersum', 'Nieuwegein', 'Rhenen', 'Utrecht', 'Veenendaal', 'Vreeland', 'Woerden', 'Zeist', 'Arnemuiden', 'Goes', 'Hulst', 'Middelburg', 'Sluis', 'Terneuzen', 'Veere', 'Vlissingen (English: Flushing)', 'Zierikzee' ]

@status_array = ['available', 'looking', 'open', 'listening', 'happy']

@descriptions = ["Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."]

@degrees = [ 'Anthropology', 'Applied Physics', 'Art', 'Biochemistry and Molecular Biology', 'Bioengineering', 'Bioinformatics', 'Biology', 'Business Management Economics', 'Chemistry', 'Classical Studies', 'Cognitive Science', 'Computer Engineering', 'Computer Science', 'Computer Game Design', 'Earth Sciences', 'Ecology and Evolution', 'Economics', 'Education and Teaching', 'Electrical Engineering', 'Environmental Studies', 'Feminist Studies', 'Field and Exchange', 'Film and Digital Media', 'German Studies', 'Global Economics', 'History', 'History of Art and Visual Culture', 'Human Biology', 'Individual Major', 'Italian Studies', 'Jewish Studies', 'Language Studies', 'Latin American and Latino Studies', 'Legal Studies', 'Linguistics', 'Literature', 'Marine Biology', 'Mathematics', 'Molecular, Cell, and Developmental Biology', 'Music', 'Network and Digital Technology', 'Neuroscience', 'Philosophy', 'Physics', 'Physics (Astrophysics)', 'Physics Education', 'Plant Sciences', 'Politics', 'Prelaw ', 'Premedicine', 'Psychology', 'Robotics Engineering', 'Sociology', 'Technology and Information Management', 'Theater Arts', 'Writing' ]
@degree_types = ['Certification', 'Diploma', 'Assopciate degree', 'Bachelor of Arts (Hons)', 'Bachelor of Arts (BA)', 'Bachelor of Arts', 'BA', 'Bachelor of Science (Hons)', 'Bachelor of Science (BS)', 'Bachelor of Science', 'BS', "Bachelor's", 'Master of Arts (Hons)', 'Master of Arts (MA)', 'Master of Arts', 'MA', 'Master of Science (Hons)', 'Master of Science (MS)', 'Master of Science', 'MS', "Master's", 'Research doctorate', 'Professional doctoral degree' ]

@companies = [ '2L Alliance', 'ABN Amro', 'AEGON', 'Ahold', 'Akzo Nobel', 'Amstel', 'ASML Holding', 'APM Terminals', 'Australian Homemade', 'Avanade', 'AVEBE', 'Basell Polyolefins', 'Bas Trucks', 'Bavaria', 'Beter Bed', 'Bip Candy', 'Koninklijke Boskalis Westminster', 'Combined Computer Services', 'CNH Global', 'Cordys', 'DAF Trucks', 'DSM', 'eBuddy', 'Exact Software', 'Endemol', 'Fortis', 'Friesland Foods', 'Fugro', 'Getronics', 'Grolsch', 'Hagemeyer', 'Heineken International', 'HEMA BV.', 'Holland Coffee and Tea', 'IKEA', 'ING Group', 'IPTP Networks', 'KLM', 'KPMG', 'KPN', 'Lucas Bols', 'Martinair', 'Mobileye', 'Norfolkline', 'NXP', 'Philips', 'Rabobank', 'Randstad', 'Reed Elsevier', 'Elsevier', 'Royal Dutch Shell', 'SBM Offshore', 'SHV Holdings', 'Simplify-It', 'Spyker Cars', 'Stork', 'SVS Printing', 'TNT', 'Telfort', 'TMF Group', 'TomTom', 'Transavia', 'Triodos Bank', 'Trust Computer Products', 'Unilever', 'Vedior', 'VNU', 'Waack', 'Wavin', 'Wolters Kluwer' ]
@positions = [ 'Abbot', 'Abstract Clerk', 'Abstract Writer', 'Abstractor', 'Academic Counsellor', 'Account Analyst', 'Account Information Clerk', 'Account Manager Sales', 'Account Specialist', 'Account Supervisor', 'Accountant', 'Accountant Assistant', 'Accountant Budget', 'Accountant Financial Analyst', 'Accountant Plant', 'Accountant Public', 'Accountant Taxation', 'Accounting Clerk', 'Accounting Data Technician', 'Accounting Director', 'Accounting Manager', 'Accounting Supervisor (General)', 'Accounting Supervisor (Professional)', 'Accounting Technician', 'Accounts Payable Clerk', 'Accounts Payable Manager', 'Accounts Payable Supervisor', 'Accounts Receivable Clerk', 'Accounts Receivable Manager', 'Accounts Receivable Supervisor', 'Acquisitions Librarian', 'Actor', 'Actuary (Associate)', 'Actuary (Enrolled)', 'Actuary (Fellow)', 'Acupressurist', 'Administration Branch Manager Banking', 'Administration Director', 'Administrative Assistant', 'Administrative Assistant, CEO', 'Administrative Engineering Manager', 'Administrative Engineering Supervisor', 'Administrative Secretary', 'Administrative Services Manager', 'Administrator Benefits', 'Administrator College', 'Administrator Contract', 'Administrator Hospital', 'Administrator School (Primary/High School)', 'Administrator Systems', 'Administrator TQM', 'Administrator Web', 'Admissions Clerk', 'Admitting Head Hospital', 'Admitting Specialist', 'Adult Education Teacher', 'Advance Agent', 'Advertising Clerk', 'Advertising Director', 'Advertising Manager', 'Advertising Production Supervisor', 'Advertising Supervisor', 'Advertising Top Officer', 'Adviser Contract', 'Adviser Personnel', 'Adviser Resources Human', 'Adviser Safety', 'Adviser Security', 'Aerodynamicist', 'Aerodynamics Engineer', 'Aeronautical Engineer', 'Aeroplane & Engine Inspector', 'Aeroplane Cabin Attendant', 'Aeroplane Captain', 'Aeroplane First Officer', 'Aeroplane Flight Attendant', 'Aeroplane Inspector', 'Aeroplane Navigator', 'Aeroplane Patrol Pilot', 'Aeroplane Pilot Commercial', 'Affirmative Action Specialist', 'Agent Advance', 'Agent Bonding', 'Agent Cargo', 'Agent Claims General', 'Agent Entertainment', 'Agent Foreign', 'Agent Manufacturers', 'Agent Patent', 'Agent Real Estate Supervisor', 'Agent Reservation', 'Agent Security', 'Agent Service Customer', 'Agent Services Customer', 'Agent Special Insurance', 'Agent Special Insurance Group', 'Agent Ticket', 'Agent Traffic', 'Agent Travel', 'Agricultural Engineer', 'Agronomist', 'Aid Laboratory', 'Aid Teachers', 'Aide - Developmental Disabilities', 'Aide Biological', 'Aide Dietary', 'Aide Geological', 'Aide Home Care', 'Aide Legal', 'Aide Mental Retardation', 'Aide Nurse', 'Aide Occupational Therapy', 'Aide Operating Room', 'Aide Psychiatric', 'Aide Recreation', 'Aide Security', 'Aide Social Services', 'Aide Technical Test Data', 'Air Analyst', 'Air Conditioning Installer (Commercial)', 'Air Conditioning Installer (Residential)', 'Air Conditioning Servicer (Commercial)', 'Air Conditioning Servicer (Residential)', 'Air Conditioning Technician', 'Air Tester', 'Aircraft Body Repairer', 'Aircraft Engine Mechanic', 'Aircraft Flight Engineer', 'Aircraft Inspector', 'Aircraft Jet Copilot', 'Aircraft Maintenance Person', 'Aircraft Mechanic', 'Aircraft Mechanic For Props', 'Aircraft Mechanic Jet', 'Aircraft Pilot Non-Jet', 'Aircraft Sales Representative', 'Airline Security Representative', 'Airport Engineer', 'Airport Service Agent', 'Alarm Signal Monitor', 'Alteration Tailor', 'Amusement Park Attendant', 'Anaesthesiology Nurse', 'Analyst Air', 'Analyst Benefits', 'Analyst Budget', 'Analyst Business', 'Analyst Business E-Commerce', 'Analyst Business Systems', 'Analyst Cephalometric', 'Analyst Classification', 'Analyst Communications', 'Analyst Compensation', 'Analyst Computer Network', 'Analyst Computer Systems Hardware', 'Analyst Credit', 'Analyst Crime Lab', 'Analyst Data Security', 'Analyst Database', 'Analyst Economic', 'Analyst Financial', 'Analyst Financial Accountant', 'Analyst Insurance Research', 'Analyst Internet Traffic', 'Analyst Inventory', 'Analyst Investment', 'Analyst Job', 'Analyst Lead Systems', 'Analyst Loan Review', 'Analyst Logistics', 'Analyst Methods & Procedures', 'Analyst Operations Research', 'Analyst Organisation', 'Analyst Personal Computer', 'Analyst Personnel', 'Analyst Planning', 'Analyst Product Design', 'Analyst Programmer', 'Analyst Quality Assurance', 'Analyst Rate', 'Analyst Research Market', 'Analyst Risk Management', 'Analyst Sales', 'Analyst Securities', 'Analyst Standards', 'Analyst Stress', 'Analyst System', 'Analyst Traffic Rate', 'Analyst User Support', 'Analyst Wage & Salary', 'Analyst Website Traffic', 'Animal Hospital Clerk', 'Animal Scientist', 'Animal Warden', 'Applications & Programming Supervisor', 'Applications Programmer', 'Applications Programming Manager', 'Appraiser & Valuer', 'Appraiser Art', 'Appraiser Commercial', 'Appraiser Motor Vehicle Damage', 'Appraiser Residential', 'Arc Cutter', 'Arc-Air Operator', 'Arcade Attendant', 'Archaeologist', 'Architect', 'Architect Data', 'Architect Database', 'Architect Landscape', 'Architectural Drafter', 'Archivist', 'Area Manager Retail', 'Armoured Car Guard & Driver', 'Arranger Floral', 'Arranger Flower', 'Art Appraiser', 'Art Director', 'Art Supervisor', 'Artist & Designer Fashion', 'Artist Display', 'Artist Fashion', 'Artist Floral', 'Artist Paste-Up', 'Asphalt Paving Machine Operator', 'Assembler Bicycle', 'Assembler Electronics', 'Assembler Electronics (General)', 'Assembler Fabricator', 'Assembler Metal Fabricator', 'Assembler Office Machines', 'Assembler Product (Bench)', 'Assembler Product (Machine)', 'Assembler Structural', 'Assembly Line Foreman', 'Assembly Supervisor', 'Assistant Accountant', 'Assistant Administrative', 'Assistant Auditor', 'Assistant Buyer', 'Assistant Certified Nurse', 'Assistant Chef', 'Assistant Chief Executive', 'Assistant Clerk', 'Assistant Construction Superintendent', 'Assistant Controller', 'Assistant Editorial', 'Assistant Estimator', 'Assistant Foreman', 'Assistant Kitchen', 'Assistant Library', 'Assistant Manager Banking Branch (Major Branch)', 'Assistant Manager Banking Branch (Minor Branch)', 'Assistant Manager Retail Store (Experience)', 'Assistant Manager Retail Store (Revenue)', 'Assistant Nurse', 'Assistant Plant Manager', 'Assistant Production Supervisor', 'Assistant Professor', 'Assistant Resource Human', 'Assistant Sales', 'Assistant Service Room', 'Assistant Supervisor Teller', 'Assistant Surgery', 'Assistant Treasurer Corporate', 'Assistant Undertaker', 'Associate Professor', 'Astronomer', 'Athletic Coach', 'Atmospheric Scientist', 'Attendant Amusement Park', 'Attendant Funeral', 'Attendant Garage', 'Attendant Gate', 'Attendant Hall Dining', 'Attendant Laundry', 'Attendant Library', 'Attendant Machine Rolling', 'Attendant Personal', 'Attendant Photographic-Process', 'Attendant Plant Sewage', 'Attendant Room Dining', 'Attendant Room Linen', 'Attendant Tool Crib', 'Attorney Director Legal', 'Attorney Practicing', 'Audiologist', 'Audiometrist', 'Audiovisual Equipment Operator', 'Audiovisual Repairer', 'Audiovisual Specialist', 'Audit Clerk', 'Audit EDP Director', 'Audit EDP Manager', 'Audit EDP Supervisor', 'Auditing Manager Internal', 'Auditing Supervisor Internal', 'Auditor Assistant', 'Auditor Information Systems', 'Auditor Internal', 'Auditor Top', 'Author', 'Author Web', 'Authoriser', 'Automobile Accessory Salesperson', 'Automobile Service Station Manager', 'Automotive Engineer', 'Automotive Lubrication Technician', 'Automotive Maintenance Repairer', 'Automotive Servicer', 'Aviation Museum Curator', 'Avionics & Radar Technician', 'Avionics Mechanic', 'Avionics Technician' ]

@professional_skills_labels = [ 'Administration support', 'Auditing', 'Budgeting', 'Clerical', 'Debt collection', 'Customer service', 'Financial management', 'Management', 'Negotiation', 'Troubleshooting', 'Allergy and Immunology', 'Anesthesiology', 'Dermatology', 'Emergency Medicine', 'Family Medicine', 'Neurology', 'Neurosurgery', 'Obstetrics & Gynecology', 'Ophthalmology', 'Cardiology', 'Endocrinology', 'Gastroenterology', 'Geriatric Medicine', 'Oncology and Hematology', 'Hospice and Palliative Medicine', 'Infectious Diseases', 'Nephrology', 'Pulmonary Diseases', 'Rheumatology', 'Administrative Law', 'Admiralty Law', 'Alternative Dispute Resolution', 'Animal Rights', 'Antitrust', 'Appellate', 'Aviation Law', 'Banking Law', 'Bankruptcy Law', 'Civil Rights', 'Community Economic Development', 'Communications Law', 'Consumer Law', 'Constitutional Law', 'Corporate Law', 'Criminal Law', 'Disability Law', 'Domestic Law', 'Elder Law', 'Entertainment & Sports Law', 'Environmental Law', 'Health Care Law', 'Homeless/Housing Law', 'Insurance Law', 'Immigration Law', 'Intellectual Property', 'International Corporate Practice', 'International Human Rights', 'Litigation', 'Military Law', 'Municipal Law', 'Patent Law', 'Real Estate/Zoning', 'Securities Law', 'Taxation', 'Tort Law', 'Trusts & Estates Law', 'Security', 'Project management', 'Software development', 'Hardware development', 'Firmware development', 'Software develpment', 'Technical support', 'Web design', 'User interface design', 'User experience design', 'Interactrion design', 'Corporate identity design', 'Logo design', '3D modeling', 'Game programming', 'Network administration', 'Architecture administration', 'Database administration', 'Architecture administration', 'Data modeling', 'Test driven development', 'Copying, collating, bindinD', 'ocument management', 'Editing', 'Event coordination', 'Filing (paper and electronic)', 'Internet research', 'Meeting coordination and planning', 'Project support', 'Proofreading', 'Report compilation and writing', 'Travel planning', 'Web conferencing coordination', 'PHP', 'Ajax', 'JQuery', 'Ruby', 'Java', 'C', 'C++', 'Ada', 'Objective-C', 'Ruby on Rails', 'SQL databases', 'CSS', 'Javascript', 'Perl', '.Net', 'Basic', 'Visual Basic', 'Assembly', 'Sewing', 'Child care', 'Making clothes', 'Money management', 'Directing procedures', 'Decorating', 'Laundry skills', 'Food preparation', 'Counseling others', 'Relating to other people', 'Formulating new ideas', 'Ironing', 'Sanding', 'House painting', 'Cabinet building', 'Ornamental woodwork', 'Building additions', 'House framing', 'Paneling', 'Furniture making', 'Insulation installation', 'Furniture refinishing', 'Relating to people', 'Supervisory experience', 'Food preparation', 'Cooking food', 'Dishwashing', 'Washing pans', 'Operating a dishwasher', 'Meal planning', 'Stocking shelves', 'Hiring', 'Directing procedures', 'Group counseling', 'Individual counseling', 'Inter-agency work', 'Interviewing', 'Writing programs', 'Supervising clients', 'Directing procedures', 'Formulating new ideas', 'Researcher', 'Crisis work', 'Lawn care', 'Public speaking', 'Writing reports', 'Flower gardening', 'Landscaping', 'Tree trimming', 'Farming', 'Transporting trees', 'Vegetable gardening', 'Pruning trees', 'Grafting', 'Greenhouse work', 'Surveying', 'Farm laborer', 'Pumping gas', 'Car tune-up', 'Changing tires', 'Auto body repair', 'Minor auto repairs', 'Selling', 'Truck driving', 'Stocking shelves', 'Car driving', 'Dusting', 'Sweeping floors', 'Washing floors', 'Waxing', 'Washing windows', 'Cleaning rugs or carpets', 'Cleaning bathrooms', 'Buffing', 'Polishing furniture', 'Plumbing repairs', 'Electrical repairs', 'Window repairs', 'Carpentry work', 'Soldering', 'Assembly line work', 'Operating machinery', 'Electrical wiring', 'Stockroom work', 'Unloading or loading', 'Quality control', 'Packing', 'Filling orders', 'Welding', 'Box making', 'Supervising others', 'Parts Stocking shelves', 'Directing procedures', 'Writing lesson plans', 'Formulating new ideas', 'Writing and grading tests', 'Directing procedures', 'Decorating classrooms', 'Making assignments', 'Setting up classroom interest centers', 'Art skills related to Music skills related to Accounting', 'Using calculators', 'Using adding machines', 'Accounts payable', 'Accounts receivable', 'Payroll', 'Income tax', 'Driving small trucks', 'Driving diesel trucks', 'Hooking and unhooking trailer from tractor', 'Backing large trucks into small openings', 'Typing', 'City driving', 'Over-the-road driving', 'Receptionist', 'Mechanical repairs', 'Diesel repairs', 'Loading and unloading', 'Changing truck tires', 'Keeping on schedule', 'General repair skills', 'Servicing office machines', 'Servicing equipment', 'Mechanically inclined', 'Relating to customers', 'Answering telephone', 'Stenography', 'Typing from dictating machines', 'Making appointments', 'Running office machines', 'Clerk duties', 'Sorting, delivering mail', 'Greeting clients', 'Calling clients', 'Directing clients', 'Researcher', 'Hair cutting', 'Styling', 'Order processing', 'Shampooing hair', 'Giving permanents and body waves', 'Cosmetics consulting', 'Facials', 'Manicures/pedicures', 'Scalp treatment', 'Hair coloring', 'Hair lightening', 'Appointment', 'Attending classes and lectures', 'Studying current beauty supplies and styles', 'Concrete work', 'Maintenance repairs', 'Plumbing', 'Heavy equipment operation', 'Truck driving', 'Brick laying', 'Trenching', 'Roofing', 'Sheet-metal work', 'Heating installation', 'Refrigeration work', 'Carpentry work', 'Heavy labor', 'Cashier', 'Waitress', 'Waiter', 'Bartender', 'Busboy', 'Handling money', 'Hostess', 'Dishwashing', 'Short order cook', 'Main cook', 'Greeting customers', 'Displaying samples', 'Demonstrating products', 'Experience in the art of persuading', 'Servicing goods', 'Delivery goods', 'Greeting customers', 'Employee relations', 'Correctly filling orders', 'Directing procedures', 'Decorating a store', 'Stocking shelves', 'Money handling', 'Inventory', 'Billing', 'Sales', 'Bookkeeping', 'Clerk', 'Directing customers', 'Customer service', 'Filing', 'Ordering supplies', 'Keeping records', 'Teaching', 'Scheduling', 'Public relations', 'Customer relations' ]

@levels       = [ 'beginner', 'intermediate', 'advanced', 'expert' ]

@language_levels = [ 'beginner', 'intermediate', 'fluent', 'native' ]
@languages = [ 'English' , 'French', 'Dutch', 'Spanish', 'Italian', 'German', 'Cantonese', 'Japanese', 'Portugese', 'Arabic', 'Hindi', 'Russian', 'Swedish', 'Norwish', 'Finnish', 'Czech']

@certificates = [ 'TOEIC', 'TOEFL', '3Com', 'Adobe', 'Adtran', 'Citrix', 'Linux Professional Institute', 'UXLabs', 'PTIT', 'CIPLE', 'DIPL', 'DALF', 'TSE']

@experiences  = (1..10).to_a

@interpersonal_skills_labels = ['Self awareness', 'Emotion management', 'Self confidence', 'Stress management', 'Resilience', 'Persistance', 'Perseverance', 'Patience', 'Flexibility', 'Autonomous', 'Team player', 'Drive', 'Rigorous', 'Work ethic', 'Reasoning', 'Creativity', 'Planning', 'Organizing', 'Multicultural Sensitivity', 'Leadership', 'Problem Solving', 'Honesty', 'Integrity', 'Morality', 'Adaptability', 'Dedication', 'Tenacity', 'Loyalty', 'Reliability', 'Responsibility', 'Dependability', 'Motivation', 'Energy', 'Passion', 'Positive attitude', 'Professionalism', 'Self-Motivated', 'Ability to work with little or no supervision', 'Willingness to learn', 'Listening', 'Writing', 'Communication', 'Managing multiple priorities', 'Attention to details' ]