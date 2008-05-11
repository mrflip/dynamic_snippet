# DynamicSnippet
class SessionController < ApplicationController
  def snippet_cookie token, text=nil
    if text.nil? 
      logger.info "Killed dynamic_snippet #{token}"
      cookies.delete(token) 
    else 
      logger.info "Set dynamic_snippet #{token} to #{text}"
      cookies[token] = text 
    end
  end

  def userid_and_name controller, action
    if logged_in?
      "#{current_user.id}##{current_user.login}"
    else
      '_#_'
    end
  end  
  
  def self.dynamic_snippet token, before_method=nil, after_method=nil
    before_filter :only => [:create, :destroy] do |controller, action|
      val = controller.send(before_method, controller, action) if before_method
      controller.snippet_cookie token, val
    end
    after_filter :only => [:create] do |controller, action|
      val = controller.send(after_method,  controller, action) if after_method
      controller.snippet_cookie token, val
    end
  end
  
end
