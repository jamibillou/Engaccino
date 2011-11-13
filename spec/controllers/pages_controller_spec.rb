require 'spec_helper'

describe PagesController do

  describe "GET 'overview'" do
    it "returns http success" do
      get 'overview'
      response.should be_success
    end
  end

  describe "GET 'walkthough'" do
    it "returns http success" do
      get 'walkthough'
      response.should be_success
    end
  end

  describe "GET 'pricing'" do
    it "returns http success" do
      get 'pricing'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
  end

end
