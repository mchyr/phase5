Creamery2012::Application.routes.draw do
  
  # Generated model routes
  resources :stores
  resources :employees
  resources :assignments
  
  # Semi-static page routes
  match 'home' => 'home#index', :as => :home
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'search' => 'home#search', :as => :search
  
  # Set the root url
  root :to => 'home#index'
  
end
