require File.join(File.dirname(__FILE__), 'fixtures_helper.rb')


isbns =  %w[9780874176292 9781556616006 9780600304340 9780099582304 9781590599150 9780395193983
            9780312062897 9781858482675 9780954161767 9780413750105 9780413732903 9781880741481
            9780413741608 9780413760104 9780413750006 9788171671946 9781882770281 9780425157299]

Book.fix {{
  :isbn         => isbns.pick,
  :created_at   => (1..100).pick.days.ago,
  :short_title  => (short = /[:sentence:]{3,5}/.gen[0...50]),
  :long_title   => /#{short} (\w+){1,3}/.gen,
  :author       => "#{/\w+/.gen.capitalize} #{/\w+/.gen.capitalize}",
  :publisher    => "#{/\w+/.gen.capitalize} #{/\w+/.gen.capitalize}",
  :notes        => /[:paragraph:]?/.gen,
  :owner => User.pick
}}

User.fixture {{
  :username => username = /\w+/.gen.downcase,
  :identity => "http://#{username}.example.com",
  :email    => "#{username}@example.com",
  :name     => "#{/\w+/.gen.capitalize} #{/\w+/.gen.capitalize}"
}}

Reservation.fixture :completed, &completed_reservation
Reservation.fixture :overdue, &overdue_reservation
Reservation.fixture :checked_out, &checked_out_reservation