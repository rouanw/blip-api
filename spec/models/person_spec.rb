require File.expand_path '../../test_helper.rb', __FILE__

require_file 'models/person.rb'

include Mongoid::Matchers

describe "Person" do
  it "should have fields mapped" do
    Person.must have_field(:auth).of_type(Hash)
    Person.must have_field(:assessments).of_type(Array)
  end
end
