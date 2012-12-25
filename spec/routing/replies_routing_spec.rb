require "spec_helper"

describe RepliesController do
  describe "routing" do

    it "routes to #index" do
      get("/replies").should route_to("replies#index")
    end

    it "routes to #new" do
      get("/replies/new").should route_to("replies#new")
    end

    it "routes to #show" do
      get("/replies/1").should route_to("replies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/replies/1/edit").should route_to("replies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/replies").should route_to("replies#create")
    end

    it "routes to #update" do
      put("/replies/1").should route_to("replies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/replies/1").should route_to("replies#destroy", :id => "1")
    end

  end
end
