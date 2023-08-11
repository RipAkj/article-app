require 'jwt'
class AuthenticationController < ApplicationController

  protect_from_forgery with: :null_session
  def create
    user = User.find_by(username: params[:username])

    if user && user.password_digest == params[:password_digest]
      payload = {
        user_id: user.id,
        exp: Time.now.to_i + 3600*24
      }
      token = JWT.encode(payload, 'your_secret_key', 'HS256')
      render json: { token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

end
