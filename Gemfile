source 'https://rubygems.org'

ruby '2.1.6'

gem 'sinatra'
gem 'sinatra-contrib'

gem 'puma'

gem "mongoid", "~> 4.0.0"
gem 'bson_ext'

gem 'activesupport'

gem 'raygun4ruby'
gem 'slack-notifier'

gem 'byebug', groups: [:development, :test]

group :test do
  gem 'database_cleaner'
  gem 'rspec', '>= 3.2'
end

group :production do
  gem 'newrelic_rpm'
end
