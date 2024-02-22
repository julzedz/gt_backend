Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      post 'login', to: 'authenticate#login'
      resources :accounts
    end
  end

# Add a catch-all route to handle routing on the frontend
  get '*path', to: 'application#index', via: :all
end
