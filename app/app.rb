require 'sinatra'
require "sinatra/json"
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-github'
require 'mongoid'
require_relative 'models/person'

use Rack::Session::Cookie, :key => 'blipsession', :secret => ENV['SESSION_SECRET'], :expire_after => 2592000

use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

before do
  cache_control :public, :must_revalidate, :max_age => 0
end

before do
  pass if request.path_info =~ /^\/auth\//
  redirect to ('/auth/twitter') unless session[:uid]
end

Mongoid.load!("config/mongoid.yml")

get '/auth/:provider/callback' do
  auth = request.env['omniauth.auth']
  person = Person.find_or_create_by(provider: auth.provider, uid: auth.uid) do |p|
    p.info = auth.info
  end
  session[:uid] = auth.uid
  session[:provider] = auth.provider
  "You have successfully signed in. Please close this window to continue."
end

get '/person' do
  person = Person.find_by(uid: session[:uid], provider: session[:provider])
  json person
end

put '/assessments' do
  person = Person.find_by(uid: session[:uid], provider: session[:provider])
  person.assessments = JSON.parse request.body.read
  person.save
end
