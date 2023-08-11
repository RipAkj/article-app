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
    @followers=Frienship.where(followed_id:@user.id)
    @followings=Friendship.where(follower_id:@user.id)
    render json:{user:@user,articles:@articles,followers:@followers,followings:@followings}
  end
  def edit
    render json:@user=User.find(params[:id])
  end
  def update
    @user = User.find(@current_user.id)
    if @user.update(params.require(:user).permit(:username, :email, :password_digest))
      render json:@user
    else
      render json: @user.errors.full_messages
    end
  end
  def index
    @users=User.all
    render json:@users
  def destroy
    @user = User.find(params[:id]).destroy
    render json:"User deleted successfully."
  end
  def showArticle
    @user = User.find(params[:id])
    @articles=@user.articles
    render json:@articles
  end
  def search
    #@users=User.match(:title => params[:s])
    #@users= User.find(:all, :conditions => ['username LIKE ?', "%#{params[:s]}%"])
    #@users=User.where(["username LIKE :params[:s]"])
    @users=User.where("username LIKE ?", "%#{params[:s]}%")
    render json:@users
  end
  def recommendedArticles
    @user=User.find(params[:id])
    @following=Friendship.where(followed_id:@user)
    @articlesOfFollowing=[]
    @following.each do |user|
      @a=Article.where(user_id:user)
      @a.each do |a1|
        @articlesOfFollowing.push(a1)
      end
      #@a=user.articles
      #@articlesOfFollowing.push(user)
    end
    render json:@articlesOfFollowing
    # @articles=Article.where(user_id: if @foloowing.)
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
