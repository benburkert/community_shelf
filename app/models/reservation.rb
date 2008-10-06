class Reservation
  include DataMapper::Resource

  ## Properties
  property :id,           Serial
  property :created_at,   DateTime,   :nullable => false, :index => true
  property :updated_at,   DateTime,   :nullable => false, :index => true
  property :due_at,       DateTime,   :nullable => false, :index => true
  property :returned_at,  DateTime

  ## Associations
  belongs_to :user
  belongs_to :book

  ## Validations
  validates_present :user, :book

  ## Hooks
  before  :valid?,  :set_timestamp_properties
  after   :create,  :record_checkout
  after   :save,    :record_checkin

  ## Default Scope
  default_scope(:default).update(:order => [:created_at.desc])

  ## Query Methods

  def self.checked_out
    all(:returned_at => nil)
  end

  def self.overdue
    checked_out.all(:due_at.lt => DateTime.now)
  end

  def self.by(user)
    all(Reservation.user.id => user.id)
  end

  def self.for(book)
    all(Reservation.book.id => book.id)
  end

  def self.starting_in(start_at, end_at)
    all(:created_at.gte => start_at, :created_at.lte => end_at)
  end

  def self.ending_in(start_at, end_at)
    all(:returned_at.gte => start_at, :returned_at.lte => end_at)
  end

  def self.active_in(start_at, end_at)
    starting_in(start_at, end_at) + ending_in(start_at, end_at)
  end

  def self.overlapping(start_at = DateTime.now, end_at = DateTime.now)
    active_in(start_at, end_at) + all(:returned_at => nil, :created_at.lte => start_at)
  end

  def self.books
    Book.all(:id.in => all.map {|r| r.book.id})
  end

  def self.latest
    first(:order => [:updated_at.desc])
  end

  ## Instance Methods

  def checkin
    update_attributes(:returned_at => DateTime.now)
  end

  ## Hook Methods

  def record_checkout
    Activity::Checkout.create(:reservation => self, :created_at => self.created_at, :user => self.user)
  end

  def record_checkin
    Activity::Checkin.create(:reservation => self, :created_at => self.returned_at, :user => self.user) if self.returned_at.nil?
  end
end