
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if session[:user_id]==nil && user && params[:session][:password_digest]==user.password_digest
      session[:user_id] = user.id
      render json:session[:user_id]
      #render json:"Logged in successfully"
    else
      render json:"There was something wrong with your login details"

    end
  end

  def destroy
    session[:user_id] = nil

    render json: "Logged out successfully"
  end
end
