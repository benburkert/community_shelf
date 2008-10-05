namespace :dm do
  namespace :db do
    desc "generate the database with random fixtures"
    task :generate => :automigrate do
      require 'dm-sweatshop'
      require Merb.root / :spec / :fixtures

      10.times  { User.gen }
      500.times { Book.gen }
      50.times  { Reservation.gen(:overdue) }
      50.times  { Reservation.gen(:checked_out) }
      500.times { Reservation.gen(:completed) }
      500.times { Review.gen }
    end

    task :gen => :generate
  end
end