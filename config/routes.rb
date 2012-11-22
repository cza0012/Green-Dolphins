GreenDophins::Application.routes.draw do
  #fix it later
  get 'tags/:tag', to: 'questions#index', as: :tags
  #resources :tags, only: [:show, :index]
  
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
