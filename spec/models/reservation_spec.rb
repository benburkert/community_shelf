require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Book do
  describe "Query Methods" do
    describe "#checked_out" do
      before(:each) do
        DataMapper.auto_migrate!
        5.times {User.gen}
        10.times {Book.gen}
      end

      it "should only return reservations without a value for :returned_at" do
        unreturned = 5.of {Reservation.gen(:checked_out)} + 5.of {Reservation.gen(:overdue)}
        returned = 5.of {Reservation.gen(:completed)}

        Reservation.checked_out.each do |reservation|
          reservation.returned_at.should be_nil
          unreturned.should include(reservation)
          returned.should_not include(reservation)
        end
      end
    end

    describe "#overdue" do
      before(:each) do
        DataMapper.auto_migrate!
        5.times {User.gen}
        10.times {Book.gen}
      end

      it "should only returned reservations without a value for :returned_at & a :created_at value more that more than 10 days old" do
        overdue = 5.of {Reservation.gen(:overdue)}
        new_or_returned = 5.of {Reservation.gen(:checked_out)} + 5.of {Reservation.gen(:completed)}

        Reservation.overdue.each do |reservation|
          reservation.returned_at.should be_nil
          reservation.created_at.should <= 10.days.ago.to_datetime

          overdue.should include(reservation)
          new_or_returned.should_not include(reservation)
        end
      end
    end

    describe "#overdue" do
      before(:each) do
        DataMapper.auto_migrate!
        5.times {User.gen}
        10.times {Book.gen}
      end

      it "should only return reservations without a value for :returned_at & a :created_at value more that more than 10 days old" do
        overdue = 5.of {Reservation.gen(:overdue)}
        new_or_returned = 5.of {Reservation.gen(:checked_out)} + 5.of {Reservation.gen(:completed)}

        Reservation.overdue.each do |reservation|
          reservation.returned_at.should be_nil
          reservation.created_at.should <= 10.days.ago.to_datetime

          overdue.should include(reservation)
          new_or_returned.should_not include(reservation)
        end
      end
    end

    describe "#by" do
      before(:each) do
        DataMapper.auto_migrate!
        5.times {User.gen}
        10.times {Book.gen}
      end

      it "should only return reservations created by the user" do
        user, others = User.gen, 5.of {User.gen}
        revs_by_user, revs_by_others = 5.of {Reservation.gen(:completed, :user => user)}, 5.of {Reservation.gen(:completed, :user => others.pick)}

        Reservation.by(user).each do |reservation|
          reservation.user.should == user

          revs_by_user.should include(reservation)
          revs_by_others.should_not include(reservation)
        end
      end
    end

    describe "#for" do
      before(:each) do
        DataMapper.auto_migrate!
        5.times {User.gen}
        10.times {Book.gen}
      end

      it "should only return reservations for the book" do
        other_books = Book.all
        book = Book.gen

        revs_for_book = 5.of {Reservation.gen(:completed, :book => book)}
        revs_for_others = 5.of {Reservation.gen(:completed, :book => other_books.pick)}

        Reservation.for(book).each do |reservation|
          reservation.book.should == book

          revs_for_book.should include(reservation)
          revs_for_others.should_not include(reservation)
        end
      end
    end
  end
end