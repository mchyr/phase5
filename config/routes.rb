Creamery2012::Application.routes.draw do
  
  get "password_resets/new"

  # Generated model routes
  resources :stores
  resources :employees
  resources :assignments
  resources :sessions
  resources :password_resets
  resources :jobs
  resources :users
  resources :shift_jobs
  resources :shifts
  
  # Semi-static page routes
  match 'home' => 'home#index', :as => :home
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'search' => 'home#search', :as => :search
  match 'login' => 'sessions#new', :as => :login
  match 'signup' => 'users#new', :as => :signup
  
  # Set the root url
  root :to => 'home#index'
  
end
