# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    user_id 1
    sender_id 1
    content "MyText"
    read false
  end
end
