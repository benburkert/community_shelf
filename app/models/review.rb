class Review
  include DataMapper::Resource

  ## Properties
  property :id,         Serial
  property :body,       Text,     :nullable => false
  property :created_at, DateTime, :nullable => false
  property :score,      Integer,  :nullable => false

  ## Associations
  belongs_to :user
  belongs_to :book

  ## Validations
  validates_present :user, :book

  ## Hooks
  before :valid?, :set_timestamp_properties
  after :create,  :record_activity

  ## Hook Methods
  def record_activity
    Activity::BookReview.create(:review => self, :user => self.user)
  end
end
