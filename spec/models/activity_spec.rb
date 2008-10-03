require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Activity do
  describe "Query Methods" do
    describe ".recent" do
      before(:each) do
        DataMapper.auto_migrate!
        5.times {User.gen}
      end

      it "should query only activities created in the last week" do
        recent = 10.of {Activity.create(:created_at => (0..6).pick.days.ago, :user => User.pick)}
        old = 10.of {Activity.create(:created_at => (8..30).pick.days.ago, :user => User.pick)}

        Activity.recent.each do |activity|
          recent.should include(activity)
          old.should_not include(activity)
        end
      end
    end
  end
end