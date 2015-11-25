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
  person = Person.find_or_create_by(provider: auth.provider, uid: auth.uid) do |p|
    p.info = auth.info
  end
  json person
end

get '/person/:id' do
  json Person.find params[:id]
end

put '/assessments' do
  person = Person.find params[:person_id]
  person.assessments = params[:assessments]
  person.save
end
