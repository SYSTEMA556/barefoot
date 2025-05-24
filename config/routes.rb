Rails.application.routes.draw do

  resources :novels do
    resources :comments, only: [:create, :destroy]
  end
 get '/bookmarks', to: 'bookmarks#index', as: :bookmarks
  resources :tags, only: [:index, :show]

  

  root "novels#index"
    resources :novels, only: [:index, :new, :create, :show] do
    # POST /novels/preview を preview_novels_path にマッピング
    collection do
      post :preview #← プレビュー用エンドポイント
      get :my_posts    # 会員本人の公開投稿一覧
      get :drafts      # 会員本人の下書き一覧
    end
  end
  #セッション周り
  
   resources :sessions, only: [:new, :create]
   
   get "/session", to: "sessions#show", as: :session
   get "/signup", to: "users#new", as: :signup
   delete "/logout", to: "sessions#destroy"
   get "/login", to: "sessions#new"

   #resources :users, only: [:new, :create,:show,:index]
   #get "/confirm_email", to: "users#confirm_email"
  resources :password_resets, only: [:new, :create, :edit, :update]

   resources :users do
     get :confirm_email, on: :collection
     get "up" => "rails/health#show", as: :rails_health_check
   end

  resources :comments do
    member do
      get 'verify_password'
      post 'confirm_delete'
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
