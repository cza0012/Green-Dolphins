# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'SETTING UP DEFAULT USER LOGIN'
# user = User.create! :name => 'Chulakorn Aritajati', :email => 'cza0012@auburn.edu', :password => '3141085', :password_confirmation => '3141085', :confirmed_at => Time.now.utc
# puts 'New user created: ' << user.name
user2 = User.create! :name => 'Instructor User', :email => 'user2@example.com', :password => '3141085', :password_confirmation => '3141085', :confirmed_at => Time.now.utc
user3 = User.create! :name => 'TA User', :email => 'user3@example.com', :password => '3141085', :password_confirmation => '3141085', :confirmed_at => Time.now.utc
puts 'New user created: ' << user2.name
# user.add_role :admin
# user.add_role :expert
user2.add_role :expert
user2.add_role :instructor
user3.add_role :expert
user3.add_role :ta

