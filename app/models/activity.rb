class Activity
  include DataMapper::Resource

  ## Properties
  property :id,           Serial
  property :type,         Discriminator
  property :created_at,   DateTime

  ## Associations
  belongs_to :user

  ## Validations
  validates_present :user

  ## Query Methods

  def self.recent(start_at = 1.week.ago)
    all(:created_at.gte => start_at, :order => [:created_at.desc])
  end

  ## Subclasses

  class Checkout < Activity

    ## Associations
    belongs_to :reservation

    ## Validations
    validates_present :reservation
  end

  class Checkin < Activity

    ## Associations
    belongs_to :reservation

    ## Validations
    validates_present :reservation
  end

  class Submission < Activity

    ## Associations
    belongs_to :book

    ## Validations
    validates_present :book
  end

  class BookReview < Activity

    ## Associations
    belongs_to :review

    ## Validations
    validates_present :book
  end

  class Signup < Activity; end
end