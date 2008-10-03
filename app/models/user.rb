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
  after   :create, :record_activity

  ## Instance Methods

  def checkout(book, due_at = 10.days.from_now)
    checked_out = false

    transaction do
      checked_out = Reservation.create(:user => self, :book => book, :due_at => due_at).valid? if book.available?
    end

    checked_out
  end

  def short_name(truncate_at = 17)
    return name if name.length < truncate_at
    
    first, last = *name.split
    if first.size > last.size
      "#{first[0, 1]}. #{last}".truncate(truncate_at)
    else
      "#{first} #{last[0, 1]}.".truncate(truncate_at)
    end
  end

  ## Hook Methods

  def record_activity
    Activity::Signup.create(:user => self)
  end
end