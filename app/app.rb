require 'sinatra'
require "sinatra/json"
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-github'
require 'mongoid'
require_relative 'models/person'

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

Mongoid.load!("config/mongoid.yml")

get '/status' do
  json :status => 'running'
end

get '/auth/:provider/callback' do
  auth = request.env['omniauth.auth']
  json Person.create provider: auth.provider, uid: auth.uid, info: auth.info
end
