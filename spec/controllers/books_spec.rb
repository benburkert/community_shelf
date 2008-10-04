require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Books, "index action" do
  before(:each) do
    dispatch_to(Books, :index)
  end
end