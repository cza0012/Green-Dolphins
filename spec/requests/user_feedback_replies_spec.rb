require 'spec_helper'

describe "UserFeedbackReplies" do
  describe "GET /user_feedback_replies" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_feedback_replies_path
      response.status.should be(200)
    end
  end
end
