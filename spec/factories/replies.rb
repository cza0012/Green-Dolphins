# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reply do
    content "MyText"
    user_id 1
    comment_id 1
  end
end
