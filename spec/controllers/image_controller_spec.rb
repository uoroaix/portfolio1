require 'spec_helper'

describe ImageController do

  describe "GET 'image'" do
    it "returns http success" do
      get 'image'
      response.should be_success
    end
  end

  describe "GET 'product:references'" do
    it "returns http success" do
      get 'product:references'
      response.should be_success
    end
  end

end
