class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites.page(params[:page]).per(5)
  end

  def create
    @dish = Dish.find(params[:dish_id])
    current_user.favorite(@dish)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    @dish = Dish.find(params[:dish_id])
    current_user.favorites.find_by(dish_id: @dish.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
