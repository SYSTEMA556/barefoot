Rails.application.routes.draw do
  # 最初のトップページ：年齢確認ゲート
  root "age_gate#new"  # /gate へのリダイレクトなどが適切

  # 年齢確認ゲート（18歳以上かどうか）
  get  "/gate",         to: "age_gate#new"  ,    as: :gate    # フォーム
  post "/gate",         to: "age_gate#create"  # 同意処理
  post "gate/verify",   to: "gate#verify"      # 同意ボタン処理など

  # Devise 認証
  devise_for :users
  resources :users, only: [:show, :edit, :update] do
    get :confirm_email, on: :collection
    get "up", to: "rails/health#show", as: :rails_health_check
  end

  # 小説ページ一覧（同意後に遷移する場所）
  get "/home", to: "novels#index"  # 事実上のトップページ

  # 小説関連ルート
  resources :novels, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      get  :enter_password
      post :verify_password
      post :confirm_caution
      post :toggle_bookmark
    end

    collection do
      get  :bookmarks
      get  :my_posts
      get  :drafts
      post :preview
    end

    # コメント機能
    resources :comments, only: [:create, :destroy] do
      member do
        post :confirm_delete
        get  :verify_password
      end
    end

    # ブックマークのリソース化（単体）
    resource :bookmark, only: [:create, :destroy]
  end

  # ブックマーク一覧
  resources :bookmarks, only: [:index]

  # 規約表示ページ
  get 'terms_and_privacy', to: 'pages#terms_and_privacy', as: 'terms_and_privacy'

  # ログアウト確認ページ
  get 'logout/confirm', to: 'pages#logout', as: :logout_confirm

  # 開発環境のみ：メールプレビュー
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
