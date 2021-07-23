source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.3"

gem "active_model_serializers"
gem "bootsnap", ">= 1.4.4", require: false
gem "devise"
gem "devise_token_auth"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "rails", "~> 6.1.3", ">= 6.1.3.2"
gem "rails-i18n"
gem "whenever"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano3-puma"
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rbenv", "~> 2.2"
  gem "capistrano-rbenv-vars", "~> 0.1"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "sshkit-sudo"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
end
