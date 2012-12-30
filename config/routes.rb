GreenDophins::Application.routes.draw do
  
  resources :replies

  mount DjMon::Engine => 'dj_mon'

  get 'tags/questions/:tag', to: 'tags#questions', as: :questions_tags
  
  get 'tags/users/:tag', to: 'tags#users', as: :users_tags
  
  match '/notifications/:id', :controller => 'notifications', :action => 'read', as: :read_notification, :via => :put
  
  resources :notifications

  resources :good_answers

  resources :usefuls

  resources :comments

  resources :feedbacks

  resources :courses

  resources :questions
  
  resources :tags

  authenticated :user do
    root :to => 'questions#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index] do
    collection do
      get :leaderboard
    end
  end
end
