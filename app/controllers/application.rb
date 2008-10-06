class Application < Merb::Controller
  def authenticated?
    not session.user.nil?
  end
end