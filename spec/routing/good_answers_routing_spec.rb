require "spec_helper"

describe GoodAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/good_answers").should route_to("good_answers#index")
    end

    it "routes to #new" do
      get("/good_answers/new").should route_to("good_answers#new")
    end

    it "routes to #show" do
      get("/good_answers/1").should route_to("good_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/good_answers/1/edit").should route_to("good_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/good_answers").should route_to("good_answers#create")
    end

    it "routes to #update" do
      put("/good_answers/1").should route_to("good_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/good_answers/1").should route_to("good_answers#destroy", :id => "1")
    end

  end
end
