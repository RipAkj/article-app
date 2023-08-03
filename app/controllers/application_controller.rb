class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :require_user
  def current_user
    if(@current_user)
      return @current_user
    else
      if session[:user_id]
        @current_user=User.find(session[:user_id])
      end
    end
  end
  def logged_in?
    !!current_user
  end
  def require_user
    if !logged_in?
      flash[:alert] = "You must be logged in to perform this action"
      redirect_to login_path
    end
  end

end
