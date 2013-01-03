require "spec_helper"

describe NotificationMailer do
  describe "expert_notification" do
    let(:mail) { NotificationMailer.expert_notification }

    it "renders the headers" do
      mail.subject.should eq("Expert notification")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "comment_notification" do
    let(:mail) { NotificationMailer.comment_notification }

    it "renders the headers" do
      mail.subject.should eq("Comment notification")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "reply_notification" do
    let(:mail) { NotificationMailer.reply_notification }

    it "renders the headers" do
      mail.subject.should eq("Reply notification")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "good_answer_notification" do
    let(:mail) { NotificationMailer.good_answer_notification }

    it "renders the headers" do
      mail.subject.should eq("Good answer notification")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
