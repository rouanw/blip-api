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

describe "oauth login" do
  before(:each) do
    class_double('Person').as_stubbed_const(:transfer_nested_constants => true)
    allow(Person).to receive(:create)
  end

  it "should be ok" do
    get '/auth/twitter/callback'
    expect(last_response.status).to be 200
  end

  it "should return the person created" do
    allow(Person).to receive(:create).and_return({name: 'someone', uid: '123'})
    get '/auth/twitter/callback'
    expect(last_response.body).to include '{"name":"someone","uid":"123"}'
  end

  it "should create a person with selected auth info" do
    auth = {
      :provider => 'twitter',
      :uid => '123545',
      :info => Hash.new
    }
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth)
    expect(Person).to receive(:create).with(provider: auth[:provider], uid: auth[:uid], info: auth[:info])

    get '/auth/twitter/callback'
  end
end
