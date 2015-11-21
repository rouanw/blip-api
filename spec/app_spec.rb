require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "status endpoint" do
  it "should return running" do
    get '/status'
    last_response.body.must_include '{"status":"running"}'
  end
end

describe "oauth login with twitter" do
  it "should be ok" do
    get '/auth/twitter/callback'
    assert last_response.status.must_equal 200
  end

  it "should echo back the auth hash for now" do
    get '/auth/twitter/callback'
    last_response.body.must_include '{"name":"Example User"}'
  end
end
