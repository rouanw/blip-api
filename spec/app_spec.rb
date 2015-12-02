include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "oauth login" do

  before(:each) do
    @bob = Person.new
    class_double('Person').as_stubbed_const(:transfer_nested_constants => true)
    allow(Person).to receive(:find_or_create_by)
  end

  it "should be ok" do
    get '/auth/twitter/callback'
    expect(last_response.status).to be 200
  end

  it "should return a message saying that authentication is complete" do
    allow(Person).to receive(:find_or_create_by).and_return({name: 'someone', uid: '123'})
    get '/auth/twitter/callback'
    expect(last_response.body).to include 'You have successfully signed in. Please close this window to continue.'
  end

  it "should find or create a person with provider and uid" do
    auth = {
      :provider => 'twitter',
      :uid => '123545'
    }
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth)
    expect(Person).to receive(:find_or_create_by).with(provider: auth[:provider], uid: auth[:uid]).and_yield(@bob)
    get '/auth/twitter/callback'
  end

  it "should set auth info on create" do
    auth = {
      :info => {"someinfo" => 'info', "name" => 'name'}
    }
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth)
    allow(Person).to receive(:find_or_create_by).and_yield(@bob)
    get '/auth/twitter/callback'
    expect(@bob.info).to eq(auth[:info])
  end

  it "should set provider and uid on session" do
    auth = {
      :provider => 'twitter',
      :uid => '123545'
    }
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth)
    allow(Person).to receive(:find_or_create_by).with(provider: auth[:provider], uid: auth[:uid])
    get '/auth/twitter/callback'
    expect(last_request.env['rack.session']['uid']).to eq('123545')
    expect(last_request.env['rack.session']['provider']).to eq('twitter')
  end
end

describe "authentication middleware" do
  it "should allow requests for auth routes to pass" do
    get '/auth/notfound'
    expect(last_response.status).to be 404
  end

  it "should redirect other routes" do
    get '/notfound'
    expect(last_response.status).to be 302
  end

  it "should not redirect other routes if user is authenticated" do
    get '/notfound', {}, {'rack.session' => {'uid' => '444'}}
    expect(last_response.status).to be 404
  end
end

describe "update assessment" do
  before(:each) do
    class_double('Person').as_stubbed_const(:transfer_nested_constants => true)
  end

  it "update assessments for the person with matching auth properties" do
    data = ['assessment', 'assessment2']
    found = double('found person')
    allow(Person).to receive(:find_by).with({uid: "456", provider: "twitter"}).and_return(found)

    expect(found).to receive(:assessments=).with(data)
    expect(found).to receive(:save)

    put '/assessments', data.to_json, {'rack.session' => {'uid' => '456', 'provider' => 'twitter'}}
  end
end

describe "get a person" do
  before(:each) do
    class_double('Person').as_stubbed_const(:transfer_nested_constants => true)
  end

  it "update assessments for the person with matching uid and provider" do
    allow(Person).to receive(:find_by).with({uid: "456", provider: "twitter"}).and_return('name' => 'sue')
    get '/person', {}, {'rack.session' => {'uid' => '456', 'provider' => 'twitter'}}
    expect(last_response.body).to eq('{"name":"sue"}')
  end
end
