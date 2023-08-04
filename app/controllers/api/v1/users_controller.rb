module Api
  module V1
class UsersController < ApiController
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
      render 'new'
    end
  end
  def show
    @user=User.find(params[:id])
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
      render 'edit'
    end
  end
  def destroy
    @user = User.find(params[:id]).destroy
  end
  def showArticle

    @user = User.find(id=1)
    render json:@article=@user.articles
  end
end
end
end
