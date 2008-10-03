require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Activity do
  describe "#short_name" do
    before(:each) do
    end

    it "should return the full name if it is less than 17 characters" do
      user = User.make(:name => /\w{6} \w{6}/.gen)
      user.short_name.should == user.name
    end

    it "should shorten the first name if it's longer than the last" do
      first, last = /\w{13}/.gen, /\w{10}/.gen
      user = User.make(:name => "#{first} #{last}")
      user.short_name.should_not include(first)
    end

    it "should shorten the last name if it's langer than the first" do
      first, last = /\w{10}/.gen, /\w{13}/.gen
      user = User.make(:name => "#{first} #{last}")
      user.short_name.should_not include(last)
    end
  end
end