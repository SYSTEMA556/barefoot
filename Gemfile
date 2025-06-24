source "https://rubygems.org"

ruby "3.2.6"

# Rails framework
gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# Asset pipeline
gem "sprockets-rails"

# Database adapter
gem "pg", "~> 1.1"

# Web server
gem "puma", ">= 5.0"

# JavaScript and frontend
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Styling & UI
gem "bootstrap", "~> 5.3.0"
gem "sassc-rails"

# Authentication & admin
gem "devise"
gem "devise-i18n"
#gem "activeadmin"

# Pagination
gem "kaminari"
gem "bootstrap5-kaminari-views"

# API & JSON
gem "jbuilder"
  gem "ransack"
# Caching & performance
gem "redis", ">= 4.0.1"
gem "bootsnap", require: false

# Security
gem "bcrypt", "~> 3.1.7"




# Faker for development/test data
gem "faker"

# Tagging
gem "acts-as-taggable-on"

# Time zones
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Development & test gems
group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails"
  gem "capybara"
  gem "selenium-webdriver"
end

group :development do
  gem "web-console"
  gem "letter_opener", "~> 1.10"
  gem "letter_opener_web"
  gem "rails-i18n", "~> 7.0"
  gem 'rack-mini-profiler'

end

# Spring speeds up development
# gem "spring"
