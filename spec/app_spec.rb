include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "status endpoint" do
  it "should return running" do
    get '/status'
    expect(last_response.body).to include '{"status":"running"}'
  end
end

describe "oauth login with twitter" do
  it "should be ok" do
    get '/auth/twitter/callback'
    expect(last_response.status).to be 200
  end

  it "should echo back the auth hash for now" do
    get '/auth/twitter/callback'
    expect(last_response.body).to include '{"name":"Example User"}'
  end
end
