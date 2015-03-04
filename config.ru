ENV['RACK_ENV'] ||= 'development'
require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

require 'raygun4ruby'
Raygun.setup do |config|
    config.api_key = ENV["RAYGUN_APIKEY"] || 'THIS WONT WORK'
end
use Raygun::Middleware::RackExceptionInterceptor

require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'false_alarm.rb'))
run FalseAlarm
