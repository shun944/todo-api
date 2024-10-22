Rails.application.routes.draw do
  resources :users, only: [ :create, :update, :destroy]
  resources :todos, only: [:index, :show, :create, :update, :destroy]
  resources :category_masters, only: [:index, :create, :update, :destroy]

  post '/login', to: 'authentication#login'
  get '/user', to: 'users#show'
  get '/healthcheck', to: 'health_check#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
