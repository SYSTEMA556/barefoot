Rails.application.routes.draw do

  get 'tags/index'
  get 'tags/show'
  root "novels#index"
    resources :novels, only: [:index, :new, :create, :show] do
    # POST /novels/preview を preview_novels_path にマッピング
    collection do
      post :preview #これなんだったっけ。。。
      get :my_posts    # 会員本人の公開投稿一覧
      get :drafts      # 会員本人の下書き一覧
    end
  end
   resources :sessions, only: [:new, :create]
   get "/session", to: "sessions#show", as: :session


  get "/signup", to: "users#new", as: :signup
   delete "/logout", to: "sessions#destroy"
   get "/login", to: "sessions#new"

   #resources :users, only: [:new, :create,:show,:index]
   #get "/confirm_email", to: "users#confirm_email"

   resources :users do
  get :confirm_email, on: :collection
 end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check



  if Rails.env.development?
   mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
