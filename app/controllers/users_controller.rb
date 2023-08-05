
class UsersController < ApplicationController
  def index
    render json:@users = User.all
  end
  def new
    render json:@user = User.new
  end
  def create
    @user = User.new(params.require(:user).permit(:username, :email, :password_digest))
    if @user.save
      session[:user_id]=@user.id
      render json:"User was created successfully"
    else
      render json: @user.errors.full_messages
    end
  end
  def show
    @user=User.find(params[:id])
    @articles=@user.articles
    render json:@user
  end
  def edit
    render json:@user=User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update(params.require(:user).permit(:username, :email, :password_digest))
      render json:"User was updated successfully"
    else
      render json: @user.errors.full_messages
    end
  end
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
end
