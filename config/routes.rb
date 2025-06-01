# config/routes.rb

Rails.application.routes.draw do
  # ─ Devise & ActiveAdmin ──────────────────────────────────────────────────────────
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  # ────────────────────────────────────────────────────────────────────────────────
 resources :users, only: [:show, :edit, :update] do
    get :confirm_email, on: :collection
    # アプリケーションのヘルスチェック用
    get "up" => "rails/health#show", as: :rails_health_check
  end
  # トップページ：小説の一覧を表示
  root "novels#index"

  # ─ Novel（作品）関連のルーティング ───────────────────────────────────────────
  resources :novels, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    # 小説ごとのブックマーク（作成・解除）
    resources :bookmarks, only: [:create, :destroy]

    # 小説詳細ページでトグル式にブックマークを切り替え
    member do
      post :toggle_bookmark   # POST /novels/:id/toggle_bookmark
    end

    # マイページやプレビュー用のカスタムアクション
    collection do
      get  :bookmarks         # GET  /novels/bookmarks  → NovelsController#bookmarks
      get  :my_posts          # GET  /novels/my_posts   → NovelsController#my_posts
      get  :drafts            # GET  /novels/drafts     → NovelsController#drafts
      post :preview           # POST /novels/preview    → NovelsController#preview
    end

    # コメント機能のネスト（投稿前確認・削除確認付き）
    resources :comments, only: [:new, :create] do
      member do
        get  :verify_password  # GET  /novels/:novel_id/comments/:id/verify_password
        post :confirm_delete   # POST /novels/:novel_id/comments/:id/confirm_delete
      end
    end
  end
  # ────────────────────────────────────────────────────────────────────────────────

  # ─ 全ユーザーのブックマーク一覧 ───────────────────────────────────────────────
  resources :bookmarks, only: [:index]
  # ────────────────────────────────────────────────────────────────────────────────

  # ─ セッション／ユーザー関連 ───────────────────────────────────────────────────

 
  # ────────────────────────────────────────────────────────────────────────────────

  # 開発環境限定：送信メールのプレビュー
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
