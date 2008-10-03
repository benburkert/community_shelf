class Activity
  include DataMapper::Resource

  property :id,           Serial
  property :type,         Discriminator
  property :created_at,   DateTime
  property :user_id,      Integer

  belongs_to :user

  validates_present :user

  def self.recent(start_at = 1.week.ago)
    all(:created_at.gte => start_at, :order => [:created_at.desc])
  end

  class Checkout < Activity
    property :reservation_id,    Integer

    belongs_to :reservation

    validates_present :reservation
  end

  class Checkin < Activity
    property :reservation_id,   Integer

    belongs_to :reservation

    validates_present :reservation
  end

  class Submission < Activity
    property :book_id,    Integer

    belongs_to :book

    validates_present :book
  end

  class Signup < Activity; end
end