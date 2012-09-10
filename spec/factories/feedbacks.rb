# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    name "MyString"
    detail "MyText"
    photo_link "MyString"
  end
end
