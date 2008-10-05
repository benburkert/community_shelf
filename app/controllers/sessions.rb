class Sessions < Application
  before :ensure_authenticated

  def login; end
end
