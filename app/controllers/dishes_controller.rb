class DishesController < ApplicationController
  def show
    @dish = Dish.find(params[:id])
  end

  def new
    @dish = Dish.new
    @dish.ingredients.build
  end

  def create
    @dish = current_user.dishes.build(dish_params)
    if @dish.save
      flash[:success] = "料理が登録されました！"
      redirect_to dish_path(@dish)
    else
      render 'new'
    end
  end

  def edit
    @dish = Dish.find(params[:id])
  end

  def update
    @dish = Dish.find(params[:id])
    if @dish.update_attributes(dish_params)
      flash[:success] = "料理情報が更新されました！"
      redirect_to dish_path(@dish)
    else
      render 'edit'
    end
  end

  def destroy
    @dish = Dish.find(params[:id])
    if user_signed_in?
      @dish.destroy
      flash[:success] = "料理が削除されました"
      redirect_to request.referrer == user_url(@dish.user) ? user_url(@dish.user) : root_url
    else
      flash[:danger] = "他人の料理は削除できません"
      redirect_to root_path
    end
  end

  private
    def dish_params
      params.require(:dish).permit(:name, :description, :portion, :tips, :required_time, ingredients_attributes: [:id, :name, :quantity]).merge(user_id: current_user.id)
    end
end
