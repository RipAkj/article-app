class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :require_authentication, except: :create

  def create
    @user = User.new(params.require(:user).permit(:username, :email, :password_digest))
    if @user.save
      payload = {
        user_id: @user.id,
        exp: Time.now.to_i + 3600*24
      }
      token = JWT.encode(payload, 'your_secret_key', 'HS256')
      render json: {user: @user, token: token}, status: :created
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    @user=User.find(params[:id])
    @articles=@user.articles
    @followers=Friendship.where(followed_id:@user.id)
    @followings=Friendship.where(follower_id:@user.id)
    render json:{user:@user,articles:@articles,followers:@followers,followings:@followings}, status: :ok
  end

  def update
    @user = User.find(params[:id])
    if @user != @current_user
      return render json: {msg: "you are not author"}, status: :unauthorized
    end
    if @user.update(params.require(:user).permit(:username, :email, :password_digest))
      render json:@user, status: :ok
    else
      render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def index
    @users=User.all
    render json:@users,status: :ok
  end

  def destroy
    @user = User.find(params[:id])
    if @user != @current_user
      return render json: {msg: "you are not author"}, status: :unauthorized
    end
    if @user.destroy
      render json: {msg: "given user deleted succesfully"}, status: :ok
    else
      render json: {errors: @user.errors.full_messages}, status: :no_content
    end
  end

  private

  def require_authentication
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded_token = JWT.decode(token, 'your_secret_key', true, algorithm: 'HS256')
      render json: {error: "invalid token"} if !decoded_token[0]['user_id']
      @current_user = User.find(decoded_token[0]['user_id'])
    rescue JWT::DecodeError
      render json: { error: header }, status: :unauthorized
    end
  end

end
