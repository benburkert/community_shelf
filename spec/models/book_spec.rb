require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Book do

  describe ".by_catalog" do
    before(:each) do
      DataMapper.auto_migrate!
      5.times {User.gen}
    end

    it "should query only books with slug beginning with the search term" do
      term = ('a'..'y').pick
      matching_catalog = 5.of {Book.gen(:short_title => /#{term}[:sentence:]{3,5}/.gen)}
      external_catalog = 5.of {Book.gen(:short_title => /#{term.succ}[:sentence:]{3,5}/.gen)}

      Book.by_catalog(term).each do |book|
        matching_catalog.should include(book)
        external_catalog.should_not include(book)
      end
    end
  end

  describe ".added_after" do
    before(:each) do
      DataMapper.auto_migrate!
      5.times {User.gen}
    end

    it "should query only books created after a timestamp" do
      timestamp = (1...10).pick.days.ago

      in_range = 5.of {Book.gen(:created_at => timestamp)}
      out_of_range = 5.of {Book.gen(:created_at => (10..20).pick.days.ago)}

      Book.added_after(timestamp).each do |book|
        in_range.should include(book)
        out_of_range.should_not include(book)
      end
    end
  end

  describe ".added_before" do
    before(:each) do
      DataMapper.auto_migrate!
      5.times {User.gen}
    end

    it "should query only books created after a timestamp" do
      timestamp = (10..20).pick.days.ago

      in_range = 5.of {Book.gen(:created_at => timestamp)}
      out_of_range = 5.of {Book.gen(:created_at => (1...10).pick.days.ago)}

      Book.added_before(timestamp).each do |book|
        in_range.should include(book)
        out_of_range.should_not include(book)
      end
    end
  end

  describe "#title" do
    it "should not be blank unless both the short & long titles are blank" do
      book = Book.new(:short_title => "short", :long_title => "long")
      book.title.should_not be_blank

      book.short_title = book.long_title = ""
      book.title.should be_blank
    end

    it "should return the short title unless it's blank" do
      book = Book.new(:short_title => "short", :long_title => "long")
      book.title.should == book.short_title

      book.short_title = ""
      book.title.should_not == book.short_title
    end

    it "should return the long title only if the short title is blank" do
      book = Book.new(:long_title => "long")
      book.title.should == book.long_title

      book.short_title = "short"
      book.title.should_not == book.long_title
    end
  end

  describe "#overdue?" do
    before(:each) do
      DataMapper.auto_migrate!
      5.times {User.make}
    end

    it "should be true if there are no overdue reservations" do
      book = Book.make
      Reservation.make(:book => book)

      book.should_not be_overdue
    end
  end
end