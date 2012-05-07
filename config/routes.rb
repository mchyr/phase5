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
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'signup' => 'users#new', :as => :signup
  match 'store_locations' => 'home#store_locations', :as => :store_locations
  match 'admin_dash' => 'home#admin', :as => :admin_dash
  match 'manager_dash' => 'home#manager', :as => :manager_dash
  match 'employee_dash' => 'home#employee', :as => :employee_dash
  match 'inactive_stores' => 'stores#_inactive_stores', :as => :inactive_stores
  match 'past_employees' => 'employees#_inactive_employees', :as => :past_employees
  match 'past_assignments' => 'assignments#_past_assignments', :as => :past_assignments
  match 'inactive_jobs' => 'jobs#index', :as => :inactive_jobs
  
  # Set the root url
  root :to => 'home#index'
  
end
