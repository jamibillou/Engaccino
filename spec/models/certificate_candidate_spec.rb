require 'spec_helper'

describe CertificateCandidate do
  before(:each) do
    @attr                  = { :description => 'I did it, I passed this certificate !' }
    @candidate             = Factory(:candidate)
    @certificate           = Factory(:certificate)
    @certificate_candidate = Factory(:certificate_candidate, :candidate => @candidate, :certificate => @certificate)
  end
  
  it "should create an instance given valid attributes" do
    certificate_candidate                 = CertificateCandidate.new(@attr)
    certificate_candidate.candidate       = @candidate
    certificate_candidate.certificate     = @certificate
    certificate_candidate.should be_valid
  end
  
  describe "candidate associations" do
  
    it "should have a candidate attribute" do
      @certificate_candidate.should respond_to(:candidate)
    end
    
    it "should have the right associated candidate" do
      @certificate_candidate.candidate_id.should == @candidate.id
      @certificate_candidate.candidate.should    == @candidate
    end
  end
  
  describe "certificate associations" do
  
    it "should have a certificate attribute" do
      @certificate_candidate.should respond_to(:certificate)
    end
    
    it "should have the right associated certificate" do
      @certificate_candidate.certificate_id.should == @certificate.id
      @certificate_candidate.certificate.should    == @certificate
    end
  end
  
  describe "validations" do
  
    it "should require a description" do
      no_description_certificate_candidate                       = CertificateCandidate.new @attr.merge(:description => '')
      no_description_certificate_candidate.candidate             = @candidate
      no_description_certificate_candidate.certificate           = @certificate
      no_description_certificate_candidate.should_not be_valid
    end
    
    it "should reject too short descriptions" do
      short_description_certificate_candidate                    = CertificateCandidate.new @attr.merge(:description => 'a'*19)
      short_description_certificate_candidate.candidate          = @candidate
      short_description_certificate_candidate.certificate        = @certificate
      short_description_certificate_candidate.should_not be_valid
    end
    
    it "should reject too long descriptions" do
      long_description_certificate_candidate                     = CertificateCandidate.new @attr.merge(:description => 'a'*161)
      long_description_certificate_candidate.candidate           = @candidate
      long_description_certificate_candidate.certificate         = @certificate
      long_description_certificate_candidate.should_not be_valid
    end
  end
end
# == Schema Information
#
# Table name: certificate_candidates
#
#  id             :integer(4)      not null, primary key
#  description    :string(255)
#  candidate_id   :integer(4)
#  certificate_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

