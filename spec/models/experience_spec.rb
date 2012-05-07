require 'spec_helper'

describe Experience do

  before :each do
    @attr       = { :role => 'UX Designer', :start_month => 7, :start_year => 2009, :end_month => 2, :end_year => 2011, :description => 'Designed web-apps mostly, a bit for mobiles as well.' }
    @candidate  = Factory :candidate
    @company    = Factory :company
    @experience = Factory :experience, :candidate => @candidate, :company => @company
  end
  
  it 'should create a new instance given valid attributes' do
    experience = Experience.new @attr ; experience.candidate = @candidate ; experience.company = @company ; experience.save!
    experience.should be_valid
  end
  
  describe 'candidate associations' do
    
    it { @experience.should respond_to :candidate }
    
    it 'should not be valid without a candidate' do
      experience_without_candidate = Experience.new @attr ; experience_without_candidate.company = @company
      experience_without_candidate.should_not be_valid
    end
    
    it 'should have the right associated candidate' do
      @experience.candidate_id.should == @candidate.id
      @experience.candidate.should    == @candidate
    end
  end
  
  describe 'company associations' do
    
    it { @experience.should respond_to :company }
    
    it 'should not be valid without a company' do
      experience_without_company = Experience.new @attr ; experience_without_company.candidate = @candidate
      experience_without_company.should_not be_valid
    end
    
    it 'should have the right associated company' do
      @experience.company_id.should == @company.id
      @experience.company.should    == @company
    end
  end
  
  describe 'validations' do
    
    it { should validate_presence_of :candidate_id }
    it { should validate_presence_of :company }
    
    it { should validate_presence_of :role }
    it { should ensure_length_of(:role).is_at_most 80 }
    
    it { should_not validate_presence_of :description }
    it { should ensure_length_of(:description).is_at_least(20).is_at_most 300 }
    
    it { should validate_presence_of :start_month }
    it { should ensure_inclusion_of(:start_month).in_range 1..12 }
    it { should validate_presence_of :start_year }
    it { should ensure_inclusion_of(:start_year).in_range 100.years.ago.year..Time.now.year }
    
    context 'current experience' do
      it 'should require neither end month nor end year' do
        experience = Experience.new @attr.merge :end_month => '', :end_year => '' ; experience.candidate = @candidate ; experience.company = @company
        experience.toggle!(:current)
        experience.should be_valid
      end
    end
    
    context 'other experience' do
    
      it { should validate_presence_of :end_month }
      it { should ensure_inclusion_of(:end_month).in_range 1..12 }
      it { should validate_presence_of :end_year }
      it { should ensure_inclusion_of(:end_year).in_range 100.years.ago.year..Time.now.year }
      
      it 'should reject start years greater than end years' do
        incoherent_experience = Experience.new :start_year => 2010, :start_month => 1, :end_year => 2009, :end_month => 10, :role => 'Bla'
        incoherent_experience.candidate = @candidate ; incoherent_experience.company = @company
        incoherent_experience.should_not be_valid
      end
    
      context 'start and end years are the same' do
      
        it 'should reject start months greater than end months' do
          incoherent_experience = Experience.new :start_year => 2009, :start_month => 5, :end_year => 2009, :end_month => 3, :role => 'Bla'
          incoherent_experience.candidate = @candidate ; incoherent_experience.company = @company
          incoherent_experience.should_not be_valid
        end
      
        it 'should accept start months lower than end months' do
          coherent_experience = Factory :experience, :start_year => 2009, :start_month => 5, :end_year => 2009, :end_month => 10, :role => 'Bla', :candidate => @candidate
          coherent_experience.should be_valid
        end
      end
    
      context 'start and end years are different' do
        it 'should accept start months greater than end months' do
          coherent_experience = Factory :experience, @attr.merge(:candidate => @candidate)
          coherent_experience.should be_valid
        end
      end
    end
  end
  
  describe 'current attribute' do
    
    it { @experience.should respond_to :current }
    
    it 'should be false by default' do
      @experience.current.should be_false
    end
    
    it 'should be convertible to true' do
      @experience.toggle!(:current)
      @experience.current.should be_true
    end
  end
  
  describe 'main attribute' do
    it { @experience.should respond_to :main }
  end
  
  describe 'duration method' do
    
    it { @experience.should respond_to :duration }
    
    it 'should calculate the right number of years between the dates' do
      @experience.duration.truncate.should == 5
      @experience.duration.round.should == 6
    end
    
    it 'should calculate the right number of months between the dates' do
      (@experience.duration * 12).round.should == 67
    end
  end
  
  describe 'yrs_after_first_event method' do
    
    it { @experience.should respond_to :yrs_after_first_event }
    
    it 'should be 0 if the experience is the first event' do
      @experience.yrs_after_first_event.should == 0
    end
    
    it 'be the number of years between the the first event and the experience' do
      Factory :experience, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :role => 'Sales administrator', :candidate => @candidate
      @experience.yrs_after_first_event.floor.should == 9
    end
  end
end

# == Schema Information
#
# Table name: experiences
#
#  id           :integer(4)      not null, primary key
#  candidate_id :integer(4)
#  company_id   :integer(4)
#  start_month  :integer(4)
#  start_year   :integer(4)
#  end_month    :integer(4)
#  end_year     :integer(4)
#  description  :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  role         :string(255)
#  current      :boolean(1)      default(FALSE)
#

