require 'sinatra'
require "sinatra/json"
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-github'

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

get '/status' do
  json :status => 'running'
end

post '/auth/:name/callback' do
  auth = request.env['omniauth.auth']
  json auth
end
