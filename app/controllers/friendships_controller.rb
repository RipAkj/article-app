class FriendshipsController < ApplicationController
  def index
  end
  def create
        @user1=User.find(params[:user1_id])
        @user2=User.find(params[:user2_id])
        @user1.follow(@user2)
        if(@user1.followers.include?(@user2))
          render json:"Follow successfull"
        else
          render json:"Follow unsuccessfull"
        end
  end
  def destroy
    @user1=User.find(params[:id])
    @user2=User.find(params[:user2_id])
    @user1.unfollow(@user2)
    if(@user1.followers.include?(@user2))
      render json:"UnFollow unsuccessfull"
    else
      render json:"UnFollow successfull"
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
    render json: @people
  end
  def showFollowing
    @user=User.find(params[:id])
    @followings=Friendship.where(follower_id:@user)
    @people=[]
    @followings.each do |following|
      @a=User.find(following.followed_id)
      @people.push(@a)
    end
    render json: @people
  end
end
