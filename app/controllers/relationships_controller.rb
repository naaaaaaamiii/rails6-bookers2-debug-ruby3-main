class RelationshipsController < ApplicationController

  def create
   user = User.find(params[:user_id])
   current_user.follow(user)
   redirect_to request.referer
  end
  
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
		redirect_to request.referer
  end
  
   def followings
      user = User.find(params[:id])
      @users = user.following_users
   end
  
  def followers
      user = User.find(params[:id])
      @user = user.follower_users
  end

end
