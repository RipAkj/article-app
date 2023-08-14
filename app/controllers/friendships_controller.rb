class FriendshipsController < ApplicationController
  before_action :require_authentication
  protect_from_forgery with: :null_session

  def create
      @user1=User.find(@current_user.id)
      @user2=User.find(params[:id])
      @user1.follow(@user2)
      if(@user1.following?(@user2))
        @follow=Friendship.last
        render json: @follow, status: :created
      else
        render json:{msg:"Follow unsuccessfull"}, status: :unprocessable_entity
      end
  end

  def destroy
    @user1=User.find(@current_user.id)
    @user2=User.find(params[:id])
    @user1.unfollow(@user2)
    if(@user1.following?(@user2))
      render json: {msg: "Succesfully unfollowed user"}, status: :ok
    else
      render json:{msg:"UnFollow successfull"}, status: :unprocessable_entity
    end
  end

  def showFollowers
    @user=User.find(params[:id])
    @followers=Friendship.where(followed_id:@user)
    @people=[]
    @followers.each do |follower|
      @a=User.find(follower.follower_id)
      @people.push(@a)
    end
    render json: @people, status: :ok
  end

  def showFollowing
    @user=User.find(params[:id])
    @followings=Friendship.where(follower_id:@user)
    @people=[]
    @followings.each do |following|
      @a=User.find(following.followed_id)
      @people.push(@a)
    end
    render json: @people, status: :ok
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
