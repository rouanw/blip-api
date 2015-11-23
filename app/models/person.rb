class Person
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  field :info, type: Hash
  field :assessments, type: Array
end
