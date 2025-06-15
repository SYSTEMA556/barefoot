#!/usr/bin/env bash
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bundle exec rails db:schema:load DISABLE_DATABASE_ENVIRONMENT_CHECK=1   # 初回用
bundle exec rails db:migrate                                            # 継続用
