require "spec_helper"

describe UserFeedbackRepliesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_feedback_replies").should route_to("user_feedback_replies#index")
    end

    it "routes to #new" do
      get("/user_feedback_replies/new").should route_to("user_feedback_replies#new")
    end

    it "routes to #show" do
      get("/user_feedback_replies/1").should route_to("user_feedback_replies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_feedback_replies/1/edit").should route_to("user_feedback_replies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_feedback_replies").should route_to("user_feedback_replies#create")
    end

    it "routes to #update" do
      put("/user_feedback_replies/1").should route_to("user_feedback_replies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_feedback_replies/1").should route_to("user_feedback_replies#destroy", :id => "1")
    end

  end
end
