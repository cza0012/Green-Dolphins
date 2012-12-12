# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    content "MyText"
    line 1
    code "MyText"
    anonymous false
    hidden false
  end
end
