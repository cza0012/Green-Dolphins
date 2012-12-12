GreenDophins::Application.routes.draw do
  
  mount DjMon::Engine => 'dj_mon'

  get 'tags/questions/:tag', to: 'tags#questions', as: :questions_tags
  
  get 'tags/users/:tag', to: 'tags#users', as: :users_tags
  
  resources :notifications

  resources :good_answers

  resources :usefuls

  resources :comments

  resources :feedbacks

  resources :courses

  resources :questions

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index]
end
