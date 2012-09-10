GreenDophins::Application.routes.draw do
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
