require "spec_helper"

describe UserFeedbacksController do
  describe "routing" do

    it "routes to #index" do
      get("/user_feedbacks").should route_to("user_feedbacks#index")
    end

    it "routes to #new" do
      get("/user_feedbacks/new").should route_to("user_feedbacks#new")
    end

    it "routes to #show" do
      get("/user_feedbacks/1").should route_to("user_feedbacks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_feedbacks/1/edit").should route_to("user_feedbacks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_feedbacks").should route_to("user_feedbacks#create")
    end

    it "routes to #update" do
      put("/user_feedbacks/1").should route_to("user_feedbacks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_feedbacks/1").should route_to("user_feedbacks#destroy", :id => "1")
    end

  end
end
