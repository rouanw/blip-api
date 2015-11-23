ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require 'mongoid-rspec'

require File.expand_path '../../app/app.rb', __FILE__

OmniAuth.config.test_mode = true

def require_file path
  require File.expand_path '../../app/' + path, __FILE__
end

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include Mongoid::Matchers
end
