# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "MyString"
    content "MyText"
    code "MyText"
    error "MyText"
    anonymous 1
    timestamp "2012-09-09 17:51:45"
  end
end
