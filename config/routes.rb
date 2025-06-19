# config/routes.rb

Rails.application.routes.draw do
  devise_for :models
  # Devise + Twitter OAuth 用
 # devise_for :users, controllers: {
 #   omniauth_callbacks: 'users/omniauth_callbacks'
 # }
  devise_for :users
  # ユーザー情報編集・確認メール用
  resources :users, only: [:show, :edit, :update] do
    get :confirm_email, on: :collection
    # ヘルスチェック
    get "up" => "rails/health#show", as: :rails_health_check
  end

  # トップページ：小説一覧
  root "novels#index"
 #  get '/auth/:provider/callback', to: 'sessions#create'
  # get '/auth/failure',            to: 'sessions#failure'
  get    'logout/confirm', to: 'pages#logout', as: :logout_confirm
  get  "/gate",  to: "age_gate#new"    # フォーム
  post "/gate",  to: "age_gate#create" # 同意処理
#delete '/logout', to: 'devise/sessions#destroy', as: :logout
  # ノベル関連
  resources :novels, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    # パスワード認証用
    member do
      get  :enter_password
      post :verify_password
     post :confirm_caution  # /novels/:id/confirm_caution
    end

    # トグル式ブックマーク
    member do
      post :toggle_bookmark
    end

    # マイページ／プレビュー用
    collection do
      get  :bookmarks    # /novels/bookmarks
      get  :my_posts     # /novels/my_posts
      get  :drafts       # /novels/drafts
      post :preview      # /novels/preview
    end

    # コメント機能
    resources :comments, only: [:create, :destroy] do
      member do
        post :confirm_delete
        get  :verify_password
      end
    end

    # ── ここに追加 ──
    # ノベルごとの Bookmark リソース（作成・解除）
    resource :bookmark, only: [:create, :destroy]
    # ─────────────
  end

  # 全ユーザーのブックマーク一覧
  resources :bookmarks, only: [:index]
 # get 'logout', to: 'pages#logout', as: :logout

  # Devise のサインアウトは DELETE だから、ボタンで飛ばすの
  # 開発環境限定：送信メールプレビュー
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
