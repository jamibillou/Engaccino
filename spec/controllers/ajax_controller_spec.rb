require 'spec_helper'

describe AjaxController do

  describe "GET 'countries'" do
    it "returns http success" do
      get 'countries'
      response.should be_success
    end
  end
end