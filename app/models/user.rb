class User
  include DataMapper::Resource

  ## Properties
  property :id,               Serial
  property :identity,         URI,      :length => 256, :nullable => false, :unique => true
  property :username,         String,   :length => 64,  :nullable => false, :unique => true
  property :name,             String,   :length => 256, :nullable => false
  property :email,            String,   :length => 256, :nullable => false, :unique => true

  ## Associations
  has n, :books
  has n, :reservations
  #has n, :reviews

  ## Hooks
  #after   :create, :record_activity
end