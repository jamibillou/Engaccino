require 'spec_helper'

describe Skill do

  before :each do
    @attr      = { :label => 'Sample skill' }
    @candidate = Factory :candidate
  end
  
  it 'should create an instance given valid attributes' do
    Skill.new(@attr).should be_valid
  end
  
  describe 'validations' do
    it { should validate_presence_of :label }
    it { should ensure_length_of(:label).is_at_most 100 }
  end
end

# == Schema Information
#
# Table name: skills
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#