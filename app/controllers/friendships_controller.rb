class FriendshipsController < ApplicationController
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
    @user1=User.find(params[:user1_id])
    @user2=User.find(params[:user2_id])
    @user1.unfollow(@user2)
    if(@user1.followers.include?(@user2))
      render json:"UnFollow unsuccessfull"
    else
      render json:"UnFollow successfull"
    end
  end
end
