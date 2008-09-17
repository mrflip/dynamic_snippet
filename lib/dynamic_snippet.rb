module DynamicSnippet

protected
  def hellobar_snippet
    if logged_in?
      snippet = "#{current_user.id}##{current_user.handle}"
    else
      snippet = "_#_"
    end
  end

  # Set or explicitly delete the cookie
  def snippet_cookie token, text=nil
    if text.nil?
      cookies.delete(token)
    else
      cookies[token] = text
    end
  end

  # Sets or kills cookie on login.
  # Nil or no signout_cookie_setter kills the cookie, important to do on signout.
  # Setting the cookie from the server side isn't strictly necessary.
  #
  def self.set_cookie_on_signin token, signin_cookie_setter=nil
    after_filter :only => [:create] do |controller, action|
      val = controller.send(signin_cookie_setter,  controller, action) if signin_cookie_setter
      controller.snippet_cookie token, val
    end
  end
  # kills the cookie on signin
  def self.kill_cookie_on_signin token
    set_cookie_on_signin token, nil
  end

  #
  # Sets or kills cookie on logout.
  # Setting the cookie from the server side isn't strictly necessary.
  #
  def self.set_cookie_on_signout token, signout_cookie_setter
    before_filter :only => [:destroy] do |controller, action|
      val = controller.send(signout_cookie_setter, controller, action) if signout_cookie_setter
      controller.snippet_cookie token, val
    end
  end
  # kills the cookie on signout. This has to be done server-side.
  def self.kill_cookie_on_signout token
    set_cookie_on_signout token, nil
  end

end
