Rails.application.routes.draw do
  root "novels#index"
  resources :novels, only: [:index, :show, :new, :create]

   resources :sessions, only: [:new, :create]
   get "/session", to: "sessions#show", as: :session

   delete "/logout", to: "sessions#destroy"
   get "/login", to: "sessions#new"

   resources :users, only: [:new, :create]
   get "/confirm_email", to: "users#confirm_email"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
