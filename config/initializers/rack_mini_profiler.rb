# frozen_string_literal: true

if Rails.env.development?
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore

  # オプションで最大保持件数なども設定可能ですわ
  Rack::MiniProfiler.config.storage_options = { max_snapshots: 100 }
end
