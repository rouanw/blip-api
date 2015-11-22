class Person
  include Mongoid::Document
  field :auth, type: Hash
  field :assessments, type: Array
end
