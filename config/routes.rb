Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :users
      resources :accounts
      # ... other resources for your API
    end
  end

# Add a catch-all route to handle routing on the frontend
  get '*path', to: 'application#index', via: :all
end
