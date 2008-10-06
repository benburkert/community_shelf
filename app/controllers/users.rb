class Users < Application
  def new
    if session['openid.url'].nil? || session['openid.url'].empty?
      redirect(url(:login))
    else
      @user = User.new(:identity_url => session['openid.url'])
      render
    end
  end

  eager_cache(:create, [Dash, :index], :store => :action_store) { build_request(build_url(:dash)) }

  def create(user)
    @user = User.new(user)

    if @user.save
      session.user = @user
      redirect(url(:dash))
    else
      render(:new)
    end
  end
end
