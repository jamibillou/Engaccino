require 'spec_helper'

describe Certificate do
  
  before :all do
    @attr = { :label => 'Sample certificate' }
  end
  
  it 'should create an instance given valid attributes' do
    Certificate.create(@attr).should be_valid
  end
  
  describe 'validations' do
    it { should validate_presence_of :label }
    it { should ensure_length_of(:label).is_at_most 100 }
  end
end

# == Schema Information
#
# Table name: certificates
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

