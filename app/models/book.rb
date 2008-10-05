class Book
  include DataMapper::Resource

  ## Properties
  property :id,               Serial
  property :isbn,             String,   :length => 13,  :nullable => false
  property :created_at,       DateTime,                 :nullable => false
  property :short_title,      String,   :length => 64,  :nullable => false
  property :long_title,       String,   :length => 256
  property :author,           String,   :length => 256
  property :publisher,        String,   :length => 256
  property :notes,            Text

  ## Plugins
  is :permalink, :title, :length => 60

  ## Associations
  belongs_to :owner, :class_name => "User"
  has n, :reservations
  has n, :reviews

  ## Validations
  validates_present :title, :owner
  validates_with_method :validate_isbn

  ## Hooks
  before :valid?, :set_timestamp_properties
  after :create,  :record_activity

  ## Default Scope
  default_scope(:default).update(:order => [:slug.asc])

  ## Query Methods

  def self.by_catalog(term)
    all(:slug.like => "#{term}%")
  end

  def self.added_after(start_time)
    all(:created_at.gt => start_time, :order => [:created_at.desc])
  end

  def self.added_before(end_time)
    all(:created_at.lte => end_time, :order => [:created_at.desc])
  end

  ## Instance Methods
  
  def title
    @short_title.blank? ? @long_title : @short_title
  end

  def overdue?
    not reservations.overdue.count.zero?
  end

  def available?(*args)
    reservations.overlapping(*args).empty?
  end

  def stars
    @stars ||= self.reviews.empty? ? 0.0 :((self.reviews.avg(:score) * 2).round / 2.0)
  end

  ## Custom Validations

  def validate_isbn
    if !self.isbn.blank? && self.isbn.size != 13
      [false, "'#{@isbn}' is in an invalid ISBN format"]
    elsif ISBN_Tools.is_valid?(@isbn)
      true
    else
      [false, "'#{@isbn}' is an invalid ISBN number"]
    end
  end

  ## Hook Methods

  def record_activity
    Activity::Submission.create(:book => self, :user => self.owner)
  end
end