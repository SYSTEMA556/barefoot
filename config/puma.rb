# 変更後（シンプルに元通り）：
# Puma can serve each request in a thread from an internal thread pool.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

rails_env = ENV.fetch("RAILS_ENV") { "development" }

# HTTP のみリスン
port ENV.fetch("PORT") { 3000 }
environment rails_env

# 開発環境のみタイムアウト延長
worker_timeout 3600 if rails_env == "development"

# プロセス数設定（本番時の worker 数制御）
if rails_env == "production"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { 1 })
  if worker_count > 1
    workers worker_count
  else
    preload_app!
  end
end

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
plugin :tmp_restart
