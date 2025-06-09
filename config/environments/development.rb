
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # コード変更時にリアルタイムで再読み込み
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  # — 開発環境でも常にキャッシュを有効化 —
  config.action_controller.perform_caching       = true
  config.action_controller.enable_fragment_cache_logging = true

  # Redis をキャッシュストアに設定
  config.cache_store = :redis_cache_store, {
    url: ENV.fetch("REDIS_URL_DEV") { "redis://localhost:6379/1" },  # 開発用 Redis DB #1
    namespace: 'myapp-cache-dev',                                   # 開発用名前空間
    expires_in: 30.minutes,                                         # 有効期限は 30 分
    reconnect_attempts: 1,                                          # 再接続試行回数
    pool_size: ENV.fetch("RAILS_MAX_THREADS") { 5 },                # プールサイズ
    pool_timeout: 5,                                                # タイムアウト秒数
    #driver: :hiredis,                                               # 高速 C ドライバ
    error_handler: ->(error:, call:, instance:) {
      Rails.logger.error "Redis dev cache error: #{error.class} – #{error.message}"
    }
  }

  # 静的ファイルにもキャッシュヘッダーを付与
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{2.days.to_i}"
  }

  # ストレージ設定
  config.active_storage.service = :local

  # メーラー設定（開発用）
  config.action_mailer.delivery_method       = :letter_opener_web
  config.action_mailer.perform_deliveries    = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options   = { host: 'localhost', port: 3000 }

  # 本番環境の SMTP 設定は省略…

  # その他の開発用設定はそのまま維持
  config.action_controller.raise_on_missing_callback_actions = true
  config.active_support.deprecation          = :log
  config.active_record.migration_error       = :page_load
  config.active_record.verbose_query_logs    = true
  config.assets.quiet                        = true
end