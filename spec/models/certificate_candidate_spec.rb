require 'spec_helper'

describe CertificateCandidate do
  
  before :each do
    @attr                  = { :level_score => '550' }
    @candidate             = Factory :candidate
    @certificate           = Factory :certificate
    @certificate_candidate = Factory :certificate_candidate, :candidate => @candidate, :certificate => @certificate
  end
  
  it 'should create an instance given valid attributes' do
    certificate_candidate = CertificateCandidate.new @attr
    certificate_candidate.candidate = @candidate ; certificate_candidate.certificate = @certificate
    certificate_candidate.should be_valid
  end
  
  describe 'candidates associations' do
  
    it { @certificate_candidate.should respond_to :candidate }
    
    it 'should have the right associated candidate' do
      @certificate_candidate.candidate_id.should == @candidate.id
      @certificate_candidate.candidate.should    == @candidate
    end
  end
  
  describe 'certificates associations' do
  
    it { @certificate_candidate.should respond_to :certificate }
    
    it 'should have the right associated certificate' do
      @certificate_candidate.certificate_id.should == @certificate.id
      @certificate_candidate.certificate.should    == @certificate
    end
  end
  
  describe 'validations' do
    it { should validate_presence_of :certificate }
    it { should_not validate_presence_of :level_score }
    it { should ensure_length_of(:level_score).is_at_most 20 }
  end
end

# == Schema Information
#
# Table name: certificate_candidates
#
#  id             :integer(4)      not null, primary key
#  level_score    :string(255)
#  candidate_id   :integer(4)
#  certificate_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#