ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'false_alarm.rb'))

require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require 'rack/test'
require 'rspec'

module RSpecMixin
  include Rack::Test::Methods
  def app() FalseAlarm end
end

RSpec.configure do |config|
  config.include RSpecMixin

  DatabaseCleaner.strategy = :truncation
  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
