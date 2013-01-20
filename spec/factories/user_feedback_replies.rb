# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_feedback_reply do
    user_feedback_id ""
    user_id ""
    content "MyText"
  end
end
