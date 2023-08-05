class ApplicationController < ActionController::Base
# include JsonWebToken
  protect_from_forgery with: :null_session
  before_action :authenticate_request
  helper_method :current_user, :logged_in?, :require_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      render json:session[:user_id]
    end
  end
  private
  def authenticate_request
    header=request.headers["Authorization"]
    header=header.split(" ").last if header
    decoded=header
    @current_user=User.find(1)
  end
end
