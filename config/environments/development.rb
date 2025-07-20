require "active_support/core_ext/integer/time"

Rails.application.configure do
  # リアルタイムリロード
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  # ── キャッシュ設定 ───────────────────────────
  if ENV["DEV_USE_REDIS"] == "true"
    # ✅ Redisキャッシュモード（必要な時だけ）
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :redis_cache_store, {
      url: ENV.fetch("REDIS_URL_DEV", "redis://localhost:6379/1"),
      namespace: "myapp-cache-dev",
      expires_in: 30.minutes,
      reconnect_attempts: 1,
      pool_size: ENV.fetch("RAILS_MAX_THREADS", 5),
      pool_timeout: 5,
      error_handler: ->(error:, call:, instance:) {
        Rails.logger.error "Redis dev cache error: #{error.class} – #{error.message}"
      }
    }
  else
    # ✅ 普段の軽量モード
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # ── 静的ファイルキャッシュは軽くする（開発では低め） ─
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # ── ストレージ・メール等は変更なし ─
  config.active_storage.service = :local
  config.action_mailer.delivery_method       = :letter_opener_web
  config.action_mailer.perform_deliveries    = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options   = { host: "localhost", port: 3000 }

  config.action_controller.raise_on_missing_callback_actions = true
  config.active_support.deprecation       = :log
  config.active_record.migration_error    = :page_load
  config.active_record.verbose_query_logs = true
  config.assets.quiet                     = true
end
