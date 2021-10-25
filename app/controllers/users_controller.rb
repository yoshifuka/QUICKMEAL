class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i(show following followers)

  def show
    @dishes = @user.dishes.paginate(page: params[:page], per_page: 5)
  end

  def following
    @title = "フォロー中"
    @users = @user.following.paginate(page: params[:page], per_page: 5)
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @users = @user.followers.paginate(page: params[:page], per_page: 5)
    render 'show_follow'
  end

  private

    def set_user
      @user = User.find_by(id: params[:id])
    end
end
