#!/usr/bin/env bash
set -o errexit
set -o xtrace   # こちらを足してデバッグ出力を有効化！

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bundle exec rails db:schema:load DISABLE_DATABASE_ENVIRONMENT_CHECK=1 || true
bundle exec rails db:migrate
