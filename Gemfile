source 'https://rubygems.org'

ruby '2.2.2'

gem 'sinatra'
gem 'sinatra-contrib', github: 'sinatra/sinatra-contrib'

gem 'puma'

gem "mongoid", "~> 5.0.0"
gem 'bson_ext'

gem 'activesupport'

gem 'raygun4ruby'
gem 'slack-notifier'

group :development, :test do
  gem 'pry'
  gem 'byebug'
end

group :test do
  gem 'database_cleaner', git: 'https://github.com/DatabaseCleaner/database_cleaner.git'
  gem 'rspec', '>= 3.2'
end

group :production do
  gem 'newrelic_rpm'
end
