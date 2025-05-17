# frozen_string_literal: true

require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # 本番環境ではコードを再読み込みしない
  config.enable_reloading = false

  # 起動時にすべてのコードをロードしておく
  config.eager_load = true

  # エラーレポートは公開せず、キャッシュは有効化
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # 暗号化された credentials を読み込むためにマスターキー必須
  config.require_master_key = true

  # 静的ファイルの配信は Web サーバ（NGINX/Apache）に任せる
  # config.public_file_server.enabled = false

  # CSS の圧縮に Sass を使用
  # config.assets.css_compressor = :sass

  # アセットパイプラインのフォールバックは無効
  config.assets.compile = false

  # 画像・スタイルシート・JavaScript を CDN 等から配信する場合は asset_host を設定
  # config.asset_host = "https://assets.example.com"

  # ファイル送信用ヘッダー（必要に応じて）
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"        # Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # NGINX

  # Active Storage のサービス設定
  config.active_storage.service = :local

  # Action Cable の設定（必要に応じて）
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "https://example.com", /https:\/\/.*\.example\.com/ ]

  # SSL リバースプロキシ下でアクセスを想定
  # config.assume_ssl = true

  # 全アクセスを SSL 化、Strict-Transport-Security も有効化
  config.force_ssl = true
  if Rails.env.production?
    # Action Mailer のリンク生成用
    config.action_mailer.default_url_options = {
      host: 'barefoot-b2x6.onrender.com',
      protocol: 'https'
    }

    # ルーティングヘルパーでのリンク生成にも同様に
    Rails.application.routes.default_url_options = {
      host: 'barefoot-b2x6.onrender.com',
      protocol: 'https'
    }

    # SMTP 設定など…
  end
  # ログを STDOUT に出力
  config.logger = ActiveSupport::Logger.new(STDOUT)
                                   .tap { |l| l.formatter = ::Logger::Formatter.new }
                                   .then { |l| ActiveSupport::TaggedLogging.new(l) }

  # リクエストID をログ行頭に付加
  config.log_tags = [ :request_id ]

  # ログレベルは環境変数かデフォルトで info
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym

  # 本番用キャッシュストア（必要に応じて）
  # config.cache_store = :mem_cache_store

  # Active Job 用キューアダプタ設定（必要に応じて）
  # config.active_job.queue_adapter     = :sidekiq
  # config.active_job.queue_name_prefix = "novel_mvp_production"

  # Action Mailer キャッシュは無効
  config.action_mailer.perform_caching = false

  # メール送信エラーは例外を発生させてすぐ気づく
  config.action_mailer.raise_delivery_errors = true

  # 本番環境で実際に SMTP 経由で配信する
  config.action_mailer.delivery_method    = :smtp
  config.action_mailer.perform_deliveries = true

  # メール内 URL 生成用のホスト／プロトコル
  config.action_mailer.default_url_options = {
    host:     'barefoot-b2x6.onrender.com',
    protocol: 'https'
  }

  # メール送信用 SMTP 設定（Gmail）
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',                               # SMTP サーバ
    port:                 587,                                            # ポート
    domain:               'barefoot-b2x6.onrender.com',                   # 自ドメイン
    user_name:            Rails.application.credentials.dig(:smtp, :user_name), # Gmail アドレス
    password:             Rails.application.credentials.dig(:smtp, :password),  # アプリパスワード
    authentication:       'plain',                                        # 認証方式
    enable_starttls_auto: true,                                           # TLS 自動使用
    open_timeout:         5,                                              # 接続タイムアウト
    read_timeout:         5                                               # 読込タイムアウト
  }

  # I18n ロケールのフォールバック設定
  config.i18n.fallbacks = true

  # 非推奨警告は記録のみ（ログには出さない）
  config.active_support.report_deprecations = false

  # マイグレーション後にスキーマダンプを作らない
  config.active_record.dump_schema_after_migration = false
end
