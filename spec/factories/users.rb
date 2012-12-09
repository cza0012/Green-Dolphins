# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :user do
    name 'Tester 1'
    email 'tester1@auburn.edu'
    password 'please'
    password_confirmation 'please'
    school 'Auburn University'
    sex 1
    level 1
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
    
    trait :student do
      after(:create) {|user| user.add_role(:student)}
    end
    
   trait :admin do
      after(:create) {|user| user.add_role(:admin)}
  end
  end
end