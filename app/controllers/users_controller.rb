class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
    #フォロー機能
    @following_users = @user.following_users
    @follower_users = @user.follower_users
    # 投稿数の比較
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_users
  end

  def followers
    user = User.find(params[:id])
    @user = user.follower_users
  end


  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new

    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
    render :show
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
