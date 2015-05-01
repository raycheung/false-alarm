require 'sinatra/base'
require 'mongoid'
require 'digest/sha1'

class Alarm
  include Mongoid::Document

  INTERVALS = %w( hourly daily monthly ).freeze
  KEY_FORMAT = /[0-9a-f]{7}/

  field :key, type: String
  field :interval, type: String
  field :last_call, type: DateTime
  field :tag, type: String

  validates :key, presence: true, uniqueness: true, format: { with: KEY_FORMAT }
  validates :interval, presence: true, inclusion: { in: INTERVALS }

  def name
    tag.present? ? tag : key
  end

  def self.new_key
    begin
      key = Digest::SHA1.hexdigest(Time.current.to_s)[0..6]
    end while self.where(key: key).exists?
    key
  end
end

class FalseAlarm < Sinatra::Base
  configure do
    Mongoid.load!(File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'mongoid.yml')))
  end

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  get '/new/:interval' do |interval|
    alarm = Alarm.create(key: Alarm.new_key, interval: interval, tag: params[:tag])
    status 404 and return alarm.errors.messages.to_json unless alarm.persisted?
    alarm.key
  end

  get '/:key' do |key|
    alarm = Alarm.where(key: key).first if key.match Alarm::KEY_FORMAT
    return status 404 unless alarm
    alarm.last_call = Time.current
    raise "failed to persist" unless alarm.save
    "OK"
  end
end
