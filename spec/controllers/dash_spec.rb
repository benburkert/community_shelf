require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Dash, "index action" do
  before(:each) do
    dispatch_to(Dash, :index)
  end
end