source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.5.1"

gem "bcrypt", "3.1.12"
gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap-kaminari-views"
gem "bootstrap-sass", "3.3.7"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "date_validator", "~> 0.9.0"
gem "ffaker", "2.10.0"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "kaminari"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.1"
gem "sass-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

group :development, :test do
  gem "byebug", platforms: %i(mri mingw x64_mingw)
  gem "sqlite3"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop", "~> 0.54.0", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :production do
  gem "pg"
end
