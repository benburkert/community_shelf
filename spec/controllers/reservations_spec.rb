require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Reservations, "index action" do
  before(:each) do
    dispatch_to(Reservations, :index)
  end
end