class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i(show following followers)

  def show
    @dishes = @user.dishes.page(params[:page]).per(5)
    @record = Record.new
  end

  def following
    @title = "フォロー中"
    @users = @user.following.page(params[:page]).per(5)
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @users = @user.followers.page(params[:page]).per(5)
    render 'show_follow'
  end

  private

    def set_user
      @user = User.find_by(id: params[:id])
    end
end
