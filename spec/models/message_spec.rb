require 'spec_helper'

describe Message do
  
  before :each do
    @attr    = { :content => 'Sample content' }
    @message = Factory :message
  end
  
  it 'should create a new instance given valid attributes' do
    Message.new(@attr).should be_valid
  end
  
  describe 'validations' do
    
    it 'should require a content' do
      Message.new(:content => '').should_not be_valid
    end
    
    it 'should reject to long contents' do
      too_long_content = 'a' * 141
      Message.new(:content => too_long_content).should_not be_valid
    end
  end
end
# == Schema Information
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

