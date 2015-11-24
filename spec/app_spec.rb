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
    @bob = Person.new
    class_double('Person').as_stubbed_const(:transfer_nested_constants => true)
    allow(Person).to receive(:find_or_create_by)
  end

  it "should be ok" do
    get '/auth/twitter/callback'
    expect(last_response.status).to be 200
  end

  it "should return the person created" do
    allow(Person).to receive(:find_or_create_by).and_return({name: 'someone', uid: '123'})
    get '/auth/twitter/callback'
    expect(last_response.body).to include '{"name":"someone","uid":"123"}'
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
end

describe "update assessment" do
  before(:each) do
    class_double('Person').as_stubbed_const(:transfer_nested_constants => true)
    allow(Person).to receive(:find).and_return('')
  end

  it "update assessments for the person with a matching id" do
    params = {:person_id => '123', :assessments => ['assessment', 'assessment2']}
    found = double('found person')
    allow(Person).to receive(:find).with('123').and_return(found)

    expect(found).to receive(:assessments=).with(params[:assessments])
    expect(found).to receive(:save)

    put '/assessments', params
  end
end
