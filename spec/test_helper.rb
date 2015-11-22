ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'rack/test'
require 'mongoid'
require 'mongoid-minitest'

require File.expand_path '../../app/app.rb', __FILE__

OmniAuth.config.test_mode = true

def require_file path
  require File.expand_path '../../app/' + path, __FILE__
end
