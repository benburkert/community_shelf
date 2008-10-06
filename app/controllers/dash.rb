class Dash < Application

  cache :index, :unless => :authenticated?

  def index
    render
  end

end
