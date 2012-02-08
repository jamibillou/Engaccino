require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_candidates
  end
end
  
def make_candidates
  admin = Candidate.create! :first_name            => 'Framinic',
                            :last_name             => 'Sabatheron',
                            :city                  => 'Grenoble',         
                            :country               => 'France',     
                            :nationality           => 'France',
                            :year_of_birth         => 1984,
                            :phone                 => '+33 6 00000000',
                            :email                 => 'bg@engaccino.com',
                            :facebook_login        => 'bg@engaccino.com',
                            :linkedin_login        => 'bg@engaccino.com',
                            :twitter_login         => '@bg',
                            :password              => 'password',
                            :password_confirmation => 'password',
                            :status                => 'open',
                            :profile_completion    => 10
  admin.toggle!(:admin)
  countries    = Country.all.collect { |c| c[0] }
  dutch_cities = [ 'Almere', 'Lelystad', 'Bolsward', 'Dokkum', 'Drachten', 'Franeker', 'Harlingen', 'Heerenveen', 'Hindeloopen', 'IJlst', 'Leeuwarden', 'Sloten', 'Sneek', 'Stavoren', 'Workum', 'Apeldoorn', 'Arnhem', 'Bredevoort', 'Buren', 'Culemborg', 'Dieren', 'Doetinchem', 'Ede', 'Groenlo', 'Harderwijk', 'Hattem', 'Huissen', 'Nijkerk', 'Nijmegen', 'Tiel', 'Wageningen', 'Wijchen', 'Winterswijk', 'Zaltbommel', 'Zutphen', 'Deil', 'Enspijk', 'Appingedam', 'Delfzijl', 'Groningen', 'Hoogezand-Sappemeer', 'Stadskanaal', 'Winschoten', 'Veendam', 'Geleen', 'Gennep', 'Heerlen', 'Kerkrade', 'Kessel', 'Landgraaf', 'Maastricht', 'Montfort', 'Nieuwstadt', 'Roermond', 'Sittard', 'Schin op Geul', 'Stein', 'Thorn', 'Valkenburg aan de Geul', 'Venlo', 'Weert', 'Bergen op Zoom', 'Breda', 'Den Bosch', 'Eindhoven', 'Geertruidenberg', 'Grave', 'Helmond', 'Heusden', 'Klundert', 'Oosterhout', 'Oss', 'Ravenstein', 'Roosendaal', 'Tilburg', 'Waalwijk', 'Willemstad', 'Woudrichem', 'Alkmaar', 'Amstelveen', 'Amsterdam', 'Den Helder', 'Edam, Volendam', 'Enkhuizen', 'Haarlem', 'Heerhugowaard', 'Hilversum', 'Hoofddorp', 'Hoorn', 'Laren', 'Purmerend', 'Medemblik', 'Monnickendam', 'Muiden', 'Naarden', 'Schagen', 'Weesp', 'Zaanstad', 'Almelo', 'Blokzijl', 'Deventer', 'Enschede', 'Genemuiden', 'Hasselt', 'Hengelo', 'Kampen', 'Oldenzaal', 'Steenwijk', 'Vollenhove', 'Zwolle', 'Alphen aan den Rijn', 'Delft', 'Dordrecht', 'Gorinchem', 'Gouda', 'Leiden', 'Rotterdam', 'Spijkenisse', 'Den Haag', 'Zoetermeer', 'Amersfoort', 'Houten', 'Leersum', 'Nieuwegein', 'Rhenen', 'Utrecht', 'Veenendaal', 'Vreeland', 'Woerden', 'Zeist', 'Arnemuiden', 'Goes', 'Hulst', 'Middelburg', 'Sluis', 'Terneuzen', 'Veere', 'Vlissingen (English: Flushing)', 'Zierikzee' ]
  status_array = ['available', 'looking', 'open', 'listening', 'happy']
  years        = (55.years.ago.year..25.years.ago.year).to_a
  @descriptions = ["Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."]
  
  99.times do |n|
    full_name  = Faker::Name.name.split
    email      = "#{full_name[0].sub(' ', '').sub('.','').sub("'",'').downcase}.#{full_name[1].sub(' ', '').sub('.','').sub("'",'').downcase}@gmail.com"
    password   = 'password'
    @candidate = Candidate.new :first_name            => full_name[0],
                               :last_name             => full_name[1],
                               :city                  => dutch_cities[rand(dutch_cities.size)],         
                               :country               => 'Netherlands',     
                               :nationality           => 'Netherlands',
                               :year_of_birth         => years[rand(years.size)],
                               :phone                 => '+31 0 00000000',
                               :email                 => email,
                               :facebook_login        => email,
                               :linkedin_login        => email,
                               :password              => password,
                               :password_confirmation => password,
                               :status                => status_array[rand(status_array.size)],
                               :profile_completion    => 10
    @candidate.save!
    make_educations
    make_experiences
    make_skills_pro
    make_skills_perso
  end
end

def make_educations
  start_yrs = ((@candidate.year_of_birth + 17)..(@candidate.year_of_birth + 19)).to_a
  start_months = (8..10).to_a
  end_months   = (5..7).to_a
  degrees = [ 'Anthropology', 'Applied Physics', 'Art', 'Biochemistry and Molecular Biology', 'Bioengineering', 'Bioinformatics', 'Biology', 'Business Management Economics', 'Chemistry', 'Classical Studies', 'Cognitive Science', 'Computer Engineering', 'Computer Science', 'Computer Game Design', 'Earth Sciences', 'Ecology and Evolution', 'Economics', 'Education and Teaching', 'Electrical Engineering', 'Environmental Studies', 'Feminist Studies', 'Field and Exchange', 'Film and Digital Media', 'German Studies', 'Global Economics', 'History', 'History of Art and Visual Culture', 'Human Biology', 'Individual Major', 'Italian Studies', 'Jewish Studies', 'Language Studies', 'Latin American and Latino Studies', 'Legal Studies', 'Linguistics', 'Literature', 'Marine Biology', 'Mathematics', 'Molecular, Cell, and Developmental Biology', 'Music', 'Network and Digital Technology', 'Neuroscience', 'Philosophy', 'Physics', 'Physics (Astrophysics)', 'Physics Education', 'Plant Sciences', 'Politics', 'Prelaw ', 'Premedicine', 'Psychology', 'Robotics Engineering', 'Sociology', 'Technology and Information Management', 'Theater Arts', 'Writing' ]
  degree_types = ['Certification', 'Diploma', 'Assopciate degree', 'Bachelor of Arts (Hons)', 'Bachelor of Arts (BA)', 'Bachelor of Arts', 'BA', 'Bachelor of Science (Hons)', 'Bachelor of Science (BS)', 'Bachelor of Science', 'BS', "Bachelor's", 'Master of Arts (Hons)', 'Master of Arts (MA)', 'Master of Arts', 'MA', 'Master of Science (Hons)', 'Master of Science (MS)', 'Master of Science', 'MS', "Master's", 'Research doctorate', 'Professional doctoral degree' ]
  loops = (1..3).to_a
  loops[rand(loops.size)].times do |n|
    education             = Education.new
    education.start_month = start_months[rand(start_months.size)]
    education.start_year  = @candidate.educations(true).empty? ? start_yrs[rand(start_yrs.size)] : @candidate.last(@candidate.educations).end_year
    end_yrs               = ((education.start_year + 1 < Time.now.year ? education.start_year + 1 : Time.now.year)..(education.start_year + 2 < Time.now.year ? education.start_year + 2 : Time.now.year)).to_a
    education.end_year    = end_yrs[rand(end_yrs.size)]
    end_months            = education.start_month < 11 ? ((education.start_month + 1)..12).to_a : [12] if education.start_year == education.end_year
    education.end_month   = end_months[rand(end_months.size)]
    education.description = @descriptions[rand(@descriptions.size)][0..298]
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
  start_yrs     = (@candidate.last(@candidate.educations).end_year..(@candidate.last(@candidate.educations).end_year+1 <= Time.now.year ? @candidate.last(@candidate.educations).end_year+1 : Time.now.year)).to_a
  start_months  = (1..12).to_a
  end_months    = (1..12).to_a
  companies = [ '2L Alliance', 'ABN Amro', 'AEGON', 'Ahold', 'Akzo Nobel', 'Amstel', 'ASML Holding', 'APM Terminals', 'Australian Homemade', 'Avanade', 'AVEBE', 'Basell Polyolefins', 'Bas Trucks', 'Bavaria', 'Beter Bed', 'Bip Candy', 'Koninklijke Boskalis Westminster', 'Combined Computer Services', 'CNH Global', 'Cordys', 'DAF Trucks', 'DSM', 'eBuddy', 'Exact Software', 'Endemol', 'Fortis', 'Friesland Foods', 'Fugro', 'Getronics', 'Grolsch', 'Hagemeyer', 'Heineken International', 'HEMA BV.', 'Holland Coffee and Tea', 'IKEA', 'ING Group', 'IPTP Networks', 'KLM', 'KPMG', 'KPN', 'Lucas Bols', 'Martinair', 'Mobileye', 'Norfolkline', 'NXP', 'Philips', 'Rabobank', 'Randstad', 'Reed Elsevier', 'Elsevier', 'Royal Dutch Shell', 'SBM Offshore', 'SHV Holdings', 'Simplify-It', 'Spyker Cars', 'Stork', 'SVS Printing', 'TNT', 'Telfort', 'TMF Group', 'TomTom', 'Transavia', 'Triodos Bank', 'Trust Computer Products', 'Unilever', 'Vedior', 'VNU', 'Waack', 'Wavin', 'Wolters Kluwer' ]
  positions = [ 'Abbot', 'Abstract Clerk', 'Abstract Writer', 'Abstractor', 'Academic Counsellor', 'Account Analyst', 'Account Information Clerk', 'Account Manager Sales', 'Account Specialist', 'Account Supervisor', 'Accountant', 'Accountant Assistant', 'Accountant Budget', 'Accountant Financial Analyst', 'Accountant Plant', 'Accountant Public', 'Accountant Taxation', 'Accounting Clerk', 'Accounting Data Technician', 'Accounting Director', 'Accounting Manager', 'Accounting Supervisor (General)', 'Accounting Supervisor (Professional)', 'Accounting Technician', 'Accounts Payable Clerk', 'Accounts Payable Manager', 'Accounts Payable Supervisor', 'Accounts Receivable Clerk', 'Accounts Receivable Manager', 'Accounts Receivable Supervisor', 'Acquisitions Librarian', 'Actor', 'Actuary (Associate)', 'Actuary (Enrolled)', 'Actuary (Fellow)', 'Acupressurist', 'Administration Branch Manager Banking', 'Administration Director', 'Administrative Assistant', 'Administrative Assistant, CEO', 'Administrative Engineering Manager', 'Administrative Engineering Supervisor', 'Administrative Secretary', 'Administrative Services Manager', 'Administrator Benefits', 'Administrator College', 'Administrator Contract', 'Administrator Hospital', 'Administrator School (Primary/High School)', 'Administrator Systems', 'Administrator TQM', 'Administrator Web', 'Admissions Clerk', 'Admitting Head Hospital', 'Admitting Specialist', 'Adult Education Teacher', 'Advance Agent', 'Advertising Clerk', 'Advertising Director', 'Advertising Manager', 'Advertising Production Supervisor', 'Advertising Supervisor', 'Advertising Top Officer', 'Adviser Contract', 'Adviser Personnel', 'Adviser Resources Human', 'Adviser Safety', 'Adviser Security', 'Aerodynamicist', 'Aerodynamics Engineer', 'Aeronautical Engineer', 'Aeroplane & Engine Inspector', 'Aeroplane Cabin Attendant', 'Aeroplane Captain', 'Aeroplane First Officer', 'Aeroplane Flight Attendant', 'Aeroplane Inspector', 'Aeroplane Navigator', 'Aeroplane Patrol Pilot', 'Aeroplane Pilot Commercial', 'Affirmative Action Specialist', 'Agent Advance', 'Agent Bonding', 'Agent Cargo', 'Agent Claims General', 'Agent Entertainment', 'Agent Foreign', 'Agent Manufacturers', 'Agent Patent', 'Agent Real Estate Supervisor', 'Agent Reservation', 'Agent Security', 'Agent Service Customer', 'Agent Services Customer', 'Agent Special Insurance', 'Agent Special Insurance Group', 'Agent Ticket', 'Agent Traffic', 'Agent Travel', 'Agricultural Engineer', 'Agronomist', 'Aid Laboratory', 'Aid Teachers', 'Aide - Developmental Disabilities', 'Aide Biological', 'Aide Dietary', 'Aide Geological', 'Aide Home Care', 'Aide Legal', 'Aide Mental Retardation', 'Aide Nurse', 'Aide Occupational Therapy', 'Aide Operating Room', 'Aide Psychiatric', 'Aide Recreation', 'Aide Security', 'Aide Social Services', 'Aide Technical Test Data', 'Air Analyst', 'Air Conditioning Installer (Commercial)', 'Air Conditioning Installer (Residential)', 'Air Conditioning Servicer (Commercial)', 'Air Conditioning Servicer (Residential)', 'Air Conditioning Technician', 'Air Tester', 'Aircraft Body Repairer', 'Aircraft Engine Mechanic', 'Aircraft Flight Engineer', 'Aircraft Inspector', 'Aircraft Jet Copilot', 'Aircraft Maintenance Person', 'Aircraft Mechanic', 'Aircraft Mechanic For Props', 'Aircraft Mechanic Jet', 'Aircraft Pilot Non-Jet', 'Aircraft Sales Representative', 'Airline Security Representative', 'Airport Engineer', 'Airport Service Agent', 'Alarm Signal Monitor', 'Alteration Tailor', 'Amusement Park Attendant', 'Anaesthesiology Nurse', 'Analyst Air', 'Analyst Benefits', 'Analyst Budget', 'Analyst Business', 'Analyst Business E-Commerce', 'Analyst Business Systems', 'Analyst Cephalometric', 'Analyst Classification', 'Analyst Communications', 'Analyst Compensation', 'Analyst Computer Network', 'Analyst Computer Systems Hardware', 'Analyst Credit', 'Analyst Crime Lab', 'Analyst Data Security', 'Analyst Database', 'Analyst Economic', 'Analyst Financial', 'Analyst Financial Accountant', 'Analyst Insurance Research', 'Analyst Internet Traffic', 'Analyst Inventory', 'Analyst Investment', 'Analyst Job', 'Analyst Lead Systems', 'Analyst Loan Review', 'Analyst Logistics', 'Analyst Methods & Procedures', 'Analyst Operations Research', 'Analyst Organisation', 'Analyst Personal Computer', 'Analyst Personnel', 'Analyst Planning', 'Analyst Product Design', 'Analyst Programmer', 'Analyst Quality Assurance', 'Analyst Rate', 'Analyst Research Market', 'Analyst Risk Management', 'Analyst Sales', 'Analyst Securities', 'Analyst Standards', 'Analyst Stress', 'Analyst System', 'Analyst Traffic Rate', 'Analyst User Support', 'Analyst Wage & Salary', 'Analyst Website Traffic', 'Animal Hospital Clerk', 'Animal Scientist', 'Animal Warden', 'Applications & Programming Supervisor', 'Applications Programmer', 'Applications Programming Manager', 'Appraiser & Valuer', 'Appraiser Art', 'Appraiser Commercial', 'Appraiser Motor Vehicle Damage', 'Appraiser Residential', 'Arc Cutter', 'Arc-Air Operator', 'Arcade Attendant', 'Archaeologist', 'Architect', 'Architect Data', 'Architect Database', 'Architect Landscape', 'Architectural Drafter', 'Archivist', 'Area Manager Retail', 'Armoured Car Guard & Driver', 'Arranger Floral', 'Arranger Flower', 'Art Appraiser', 'Art Director', 'Art Supervisor', 'Artist & Designer Fashion', 'Artist Display', 'Artist Fashion', 'Artist Floral', 'Artist Paste-Up', 'Asphalt Paving Machine Operator', 'Assembler Bicycle', 'Assembler Electronics', 'Assembler Electronics (General)', 'Assembler Fabricator', 'Assembler Metal Fabricator', 'Assembler Office Machines', 'Assembler Product (Bench)', 'Assembler Product (Machine)', 'Assembler Structural', 'Assembly Line Foreman', 'Assembly Supervisor', 'Assistant Accountant', 'Assistant Administrative', 'Assistant Auditor', 'Assistant Buyer', 'Assistant Certified Nurse', 'Assistant Chef', 'Assistant Chief Executive', 'Assistant Clerk', 'Assistant Construction Superintendent', 'Assistant Controller', 'Assistant Editorial', 'Assistant Estimator', 'Assistant Foreman', 'Assistant Kitchen', 'Assistant Library', 'Assistant Manager Banking Branch (Major Branch)', 'Assistant Manager Banking Branch (Minor Branch)', 'Assistant Manager Retail Store (Experience)', 'Assistant Manager Retail Store (Revenue)', 'Assistant Nurse', 'Assistant Plant Manager', 'Assistant Production Supervisor', 'Assistant Professor', 'Assistant Resource Human', 'Assistant Sales', 'Assistant Service Room', 'Assistant Supervisor Teller', 'Assistant Surgery', 'Assistant Treasurer Corporate', 'Assistant Undertaker', 'Associate Professor', 'Astronomer', 'Athletic Coach', 'Atmospheric Scientist', 'Attendant Amusement Park', 'Attendant Funeral', 'Attendant Garage', 'Attendant Gate', 'Attendant Hall Dining', 'Attendant Laundry', 'Attendant Library', 'Attendant Machine Rolling', 'Attendant Personal', 'Attendant Photographic-Process', 'Attendant Plant Sewage', 'Attendant Room Dining', 'Attendant Room Linen', 'Attendant Tool Crib', 'Attorney Director Legal', 'Attorney Practicing', 'Audiologist', 'Audiometrist', 'Audiovisual Equipment Operator', 'Audiovisual Repairer', 'Audiovisual Specialist', 'Audit Clerk', 'Audit EDP Director', 'Audit EDP Manager', 'Audit EDP Supervisor', 'Auditing Manager Internal', 'Auditing Supervisor Internal', 'Auditor Assistant', 'Auditor Information Systems', 'Auditor Internal', 'Auditor Top', 'Author', 'Author Web', 'Authoriser', 'Automobile Accessory Salesperson', 'Automobile Service Station Manager', 'Automotive Engineer', 'Automotive Lubrication Technician', 'Automotive Maintenance Repairer', 'Automotive Servicer', 'Aviation Museum Curator', 'Avionics & Radar Technician', 'Avionics Mechanic', 'Avionics Technician' ]
  loops = (1..5).to_a
  loops[rand(loops.size)].times do |n|
    experience             = Experience.new
    experience.role        = positions[rand(positions.size)]
    experience.start_month = start_months[rand(start_months.size)]
    unless @candidate.nil? || @candidate.experiences(true).empty?
      start_yrs = (@candidate.last(@candidate.experiences).end_year..(@candidate.last(@candidate.experiences).end_year+2 <= Time.now.year ? @candidate.last(@candidate.experiences).end_year+2 : Time.now.year)).to_a
    end
    experience.start_year  = start_yrs[rand(start_yrs.size)]
    experience_end_years   = ((experience.start_year+1 < Time.now.year ? experience.start_year+1 : Time.now.year)..(experience.start_year+10 < Time.now.year ? experience.start_year+10 : Time.now.year)).to_a
    experience.end_year    = experience_end_years[rand(experience_end_years.size)]
    end_months             = experience.start_month < 11 ? ((experience.start_month + 1)..12).to_a : [12] if experience.start_year == experience.end_year
    experience.end_month   = end_months[rand(end_months.size)]
    experience.description = @descriptions[rand(@descriptions.size)][0..298]
    experience.candidate   = @candidate
    company                = experience.build_company
    company.name           = companies[rand(companies.size)]
    
    [company, experience, @candidate].each { |object| object.save! }
  end
  
  def make_skills_pro
    labels = [ 'Administration support', 'Auditing', 'Budgeting', 'Clerical', 'Debt collection', 'Customer service', 'Financial management', 'Management', 'Negotiation', 'Troubleshooting', 'Allergy and Immunology', 'Anesthesiology', 'Dermatology', 'Emergency Medicine', 'Family Medicine', 'Neurology', 'Neurosurgery', 'Obstetrics & Gynecology', 'Ophthalmology', 'Cardiology', 'Endocrinology', 'Gastroenterology', 'Geriatric Medicine', 'Oncology and Hematology', 'Hospice and Palliative Medicine', 'Infectious Diseases', 'Nephrology', 'Pulmonary Diseases', 'Rheumatology', 'Administrative Law', 'Admiralty Law', 'Alternative Dispute Resolution', 'Animal Rights', 'Antitrust', 'Appellate', 'Aviation Law', 'Banking Law', 'Bankruptcy Law', 'Civil Rights', 'Community Economic Development', 'Communications Law', 'Consumer Law', 'Constitutional Law', 'Corporate Law', 'Criminal Law', 'Disability Law', 'Domestic Law', 'Elder Law', 'Entertainment & Sports Law', 'Environmental Law', 'Health Care Law', 'Homeless/Housing Law', 'Insurance Law', 'Immigration Law', 'Intellectual Property', 'International Corporate Practice', 'International Human Rights', 'Litigation', 'Military Law', 'Municipal Law', 'Patent Law', 'Real Estate/Zoning', 'Securities Law', 'Taxation', 'Tort Law', 'Trusts & Estates Law', 'Security', 'Project management', 'Software development', 'Hardware development', 'Firmware development', 'Software develpment', 'Technical support', 'Web design', 'User interface design', 'User experience design', 'Interactrion design', 'Corporate identity design', 'Logo design', '3D modeling', 'Game programming', 'Network administration', 'Architecture administration', 'Database administration', 'Architecture administration', 'Data modeling', 'Test driven development', 'Copying, collating, bindinD', 'ocument management', 'Editing', 'Event coordination', 'Filing (paper and electronic)', 'Internet research', 'Meeting coordination and planning', 'Project support', 'Proofreading', 'Report compilation and writing', 'Travel planning', 'Web conferencing coordination', 'PHP', 'Ajax', 'JQuery', 'Ruby', 'Java', 'C', 'C++', 'Ada', 'Objective-C', 'Ruby on Rails', 'SQL databases', 'CSS', 'Javascript', 'Perl', '.Net', 'Basic', 'Visual Basic', 'Assembly', 'Sewing', 'Child care', 'Making clothes', 'Money management', 'Directing procedures', 'Decorating', 'Laundry skills', 'Food preparation', 'Counseling others', 'Relating to other people', 'Formulating new ideas', 'Ironing', 'Sanding', 'House painting', 'Cabinet building', 'Ornamental woodwork', 'Building additions', 'House framing', 'Paneling', 'Furniture making', 'Insulation installation', 'Furniture refinishing', 'Relating to people', 'Supervisory experience', 'Food preparation', 'Cooking food', 'Dishwashing', 'Washing pans', 'Operating a dishwasher', 'Meal planning', 'Stocking shelves', 'Hiring', 'Directing procedures', 'Group counseling', 'Individual counseling', 'Inter-agency work', 'Interviewing', 'Writing programs', 'Supervising clients', 'Directing procedures', 'Formulating new ideas', 'Researcher', 'Crisis work', 'Lawn care', 'Public speaking', 'Writing reports', 'Flower gardening', 'Landscaping', 'Tree trimming', 'Farming', 'Transporting trees', 'Vegetable gardening', 'Pruning trees', 'Grafting', 'Greenhouse work', 'Surveying', 'Farm laborer', 'Pumping gas', 'Car tune-up', 'Changing tires', 'Auto body repair', 'Minor auto repairs', 'Selling', 'Truck driving', 'Stocking shelves', 'Car driving', 'Dusting', 'Sweeping floors', 'Washing floors', 'Waxing', 'Washing windows', 'Cleaning rugs or carpets', 'Cleaning bathrooms', 'Buffing', 'Polishing furniture', 'Plumbing repairs', 'Electrical repairs', 'Window repairs', 'Carpentry work', 'Soldering', 'Assembly line work', 'Operating machinery', 'Electrical wiring', 'Stockroom work', 'Unloading or loading', 'Quality control', 'Packing', 'Filling orders', 'Welding', 'Box making', 'Supervising others', 'Parts Stocking shelves', 'Directing procedures', 'Writing lesson plans', 'Formulating new ideas', 'Writing and grading tests', 'Directing procedures', 'Decorating classrooms', 'Making assignments', 'Setting up classroom interest centers', 'Art skills related to Music skills related to Accounting', 'Using calculators', 'Using adding machines', 'Accounts payable', 'Accounts receivable', 'Payroll', 'Income tax', 'Driving small trucks', 'Driving diesel trucks', 'Hooking and unhooking trailer from tractor', 'Backing large trucks into small openings', 'Typing', 'City driving', 'Over-the-road driving', 'Receptionist', 'Mechanical repairs', 'Diesel repairs', 'Loading and unloading', 'Changing truck tires', 'Keeping on schedule', 'General repair skills', 'Servicing office machines', 'Servicing equipment', 'Mechanically inclined', 'Relating to customers', 'Answering telephone', 'Stenography', 'Typing from dictating machines', 'Making appointments', 'Running office machines', 'Clerk duties', 'Sorting, delivering mail', 'Greeting clients', 'Calling clients', 'Directing clients', 'Researcher', 'Hair cutting', 'Styling', 'Order processing', 'Shampooing hair', 'Giving permanents and body waves', 'Cosmetics consulting', 'Facials', 'Manicures/pedicures', 'Scalp treatment', 'Hair coloring', 'Hair lightening', 'Appointment', 'Attending classes and lectures', 'Studying current beauty supplies and styles', 'Concrete work', 'Maintenance repairs', 'Plumbing', 'Heavy equipment operation', 'Truck driving', 'Brick laying', 'Trenching', 'Roofing', 'Sheet-metal work', 'Heating installation', 'Refrigeration work', 'Carpentry work', 'Heavy labor', 'Cashier', 'Waitress', 'Waiter', 'Bartender', 'Busboy', 'Handling money', 'Hostess', 'Dishwashing', 'Short order cook', 'Main cook', "Cook's assistant", 'Greeting customers', 'Displaying samples', 'Demonstrating products', 'Experience in the art of persuading', 'Servicing goods', 'Delivery goods', 'Greeting customers', 'Employee relations', 'Correctly filling orders', 'Directing procedures', 'Decorating a store', 'Stocking shelves', 'Money handling', 'Inventory', 'Billing', 'Sales', 'Bookkeeping', 'Clerk', 'Directing customers', 'Customer service', 'Filing', 'Ordering supplies', 'Keeping records', 'Teaching', 'Scheduling', 'Public relations', 'Customer relations' ]
    levels       = [ 'beginner', 'intermediate', 'advanced', 'expert' ]
    experiences  = (1..60).to_a
    
    loops = (2..4).to_a
    loops[rand(loops.size)].times do |n|
      skill                       = SkillPro.new
      skill.label                 = labels[rand(labels.size)]
      skill_candidate             = SkillCandidate.new
      skill_candidate.level       = levels[rand(levels.size)]
      skill_candidate.experience  = experiences[rand(experiences.size)]
      skill_candidate.description = @descriptions[rand(@descriptions.size)][0..158]
      skill_candidate.skill       = skill
      skill_candidate.candidate   = @candidate
      skill_candidate.save!
    end
  end
  
  def make_skills_perso
    labels = ['Self awareness', 'Emotion management', 'Self-confidence', 'Stress management', 'Resilience', 'Persistance', 'Perseverance', 'Patience', 'Flexibility', 'Autonomous', 'Team player', 'Drive', 'Rigorous', 'Work ethic', 'Reasoning', 'Creativity', 'Planning', 'Organizing', 'Multicultural Sensitivity', 'Leadership', 'Problem-Solving', 'Honesty', 'Integrity', 'Morality', 'Adaptability', 'Dedication', 'Tenacity', 'Loyalty', 'Reliability', 'Responsibility', 'Dependability', 'Motivation', 'Energy', 'Passion', 'Positive attitude', 'Professionalism', 'Self-Motivated', 'Ability to work with little or no supervision', 'Willingness to learn', 'Listening', 'Writing', 'Communication', 'Managing multiple priorities', 'Attention to details' ]
    loops = (2..4).to_a
    loops[rand(loops.size)].times do |n|
      skill                       = SkillPerso.new
      skill.label                 = labels[rand(labels.size)]
      skill_candidate             = SkillCandidate.new
      skill_candidate.description = @descriptions[rand(@descriptions.size)][0..158]
      skill_candidate.skill       = skill
      skill_candidate.candidate   = @candidate
      skill_candidate.save!
    end
  end
end
