require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Reviews, "index action" do
  before(:each) do
    dispatch_to(Reviews, :index)
  end
end