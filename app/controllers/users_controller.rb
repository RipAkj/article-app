class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(params.require(:user).permit(:username, :email, :password_digest))
    if @user.save
      session[:user_id]=@user.id
      flash[:notice]="User was created successfully"
    else
      render 'new'
    end
  end
  def show
    @user=User.find(params[:id])
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end
  def edit
    @user=User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update(params.require(:user).permit(:username, :email, :password_digest))
      flash[:notice]="User was updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def destroy
    @user = User.find(params[:id]).destroy
    redirect_to users_path
  end
end
