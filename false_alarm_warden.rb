#!/usr/bin/env ruby
ENV['RACK_ENV'] ||= 'development'
require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'false_alarm.rb'))

Mongoid.load!(File.expand_path(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml')))

# not a server
set :run, false

Alarm.where(:created_at.lt => 15.minutes.ago, last_call: nil).each do |alarm|
  # TODO: post to webhook
  puts "Any setup error?"
end

# TODO: post to webhook
alert = -> (alarm) { puts "Alert!" }

puts "[#{ENV['RACK_ENV']}] There are: #{Alarm.count} alarms."
puts "Checking hourly alarms..."
Alarm.where(interval: 'hourly', :last_call.lt => 1.hour.ago).each &alert
puts "Checking daily alarms..."
Alarm.where(interval: 'daily', :last_call.lt => 1.day.ago).each &alert
puts "Checking monthly alarms..."
Alarm.where(interval: 'monthly', :last_call.lt => 1.month.ago).each &alert
puts "Job done, bye bye."
