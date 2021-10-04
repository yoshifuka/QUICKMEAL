class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    @dishes = @user.dishes.paginate(page: params[:page], per_page: 5)
  end
end
