# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "What is Ruby on Rails?"
    content "I did not know what is Ruby on Rails"
    code "<pre></pre>"
    error "No error"
    anonymous false
    user_id 1
  end
end
