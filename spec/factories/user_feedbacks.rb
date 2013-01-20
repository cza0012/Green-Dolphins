# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_feedback do
    title "MyString"
    content "MyText"
    type ""
    user_id ""
  end
end
