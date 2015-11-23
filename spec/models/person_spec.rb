require_file 'models/person.rb'

RSpec.describe Person, type: :model do
  it { is_expected.to have_field(:auth).of_type(Hash) }
  it { is_expected.to have_field(:assessments).of_type(Array) }
end
