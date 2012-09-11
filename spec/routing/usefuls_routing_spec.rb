require "spec_helper"

describe UsefulsController do
  describe "routing" do

    it "routes to #index" do
      get("/usefuls").should route_to("usefuls#index")
    end

    it "routes to #new" do
      get("/usefuls/new").should route_to("usefuls#new")
    end

    it "routes to #show" do
      get("/usefuls/1").should route_to("usefuls#show", :id => "1")
    end

    it "routes to #edit" do
      get("/usefuls/1/edit").should route_to("usefuls#edit", :id => "1")
    end

    it "routes to #create" do
      post("/usefuls").should route_to("usefuls#create")
    end

    it "routes to #update" do
      put("/usefuls/1").should route_to("usefuls#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/usefuls/1").should route_to("usefuls#destroy", :id => "1")
    end

  end
end
