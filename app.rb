require 'sinatra'
require "sinatra/json"
require 'omniauth'
require 'omniauth-twitter'

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :twitter, 'consumerkey', 'consumersecret'
end

get '/status' do
  json :status => 'running'
end

post '/auth/:name/callback' do
  auth = request.env['omniauth.auth']
  json auth
end
