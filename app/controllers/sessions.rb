class Sessions < Application
  before :ensure_authenticated, :exclude => :destroy

  def create
    redirect url(:dash)
  end

  def destroy
    session.abandon!

    redirect url(:dash)
  end
end
