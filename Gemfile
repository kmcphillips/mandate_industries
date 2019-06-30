source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 6.0.0.rc1'
gem 'mysql2', '>= 0.4.4'
gem 'redis'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# gem 'image_processing', '~> 1.2'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'sidekiq'
gem 'twilio-ruby'
gem 'active_operation'
gem 'kaminari'

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'capistrano', '3.6.1'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'
end
