Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'registrations', to: 'registrations#create'
      post 'sessions', to: 'sessions#create'
      delete 'sessions', to: 'sessions#destroy'
      resources :users
      post 'login', to: 'authenticate#login'
      resources :accounts
    end
  end

# Add a catch-all route to handle routing on the frontend
  get '*path', to: 'application#index', via: :all
end
