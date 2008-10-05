require File.join(File.dirname(__FILE__), 'fixtures_helper.rb')

Book.fix {{
  :isbn         => random_isbn,
  :created_at   => (1..100).pick.days.ago,
  :short_title  => (short = /[:sentence:]{3,5}/.gen[0...50]),
  :long_title   => /#{short} (\w+){1,3}/.gen,
  :author       => Randgen.name,
  :publisher    => "#{/\w+/.gen.capitalize} #{/\w+/.gen.capitalize}",
  :notes        => /[:paragraph:]?/.gen,
  :owner        => User.pick
}}

User.fixture {{
  :username     => username = /\w+/.gen.downcase,
  :identity_url => "http://#{username}.example.com",
  :email        => "#{username}@example.com",
  :name         => Randgen.name
}}

Reservation.fixture :completed, &completed_reservation
Reservation.fixture :overdue, &overdue_reservation
Reservation.fixture :checked_out, &checked_out_reservation

Review.fixture {{
  :body       => /[:paragraph:]/.gen,
  :score      => (1..5).pick,
  :book       => (reservation = Reservation.pick(:completed)).book,
  :user       => reservation.user
}}