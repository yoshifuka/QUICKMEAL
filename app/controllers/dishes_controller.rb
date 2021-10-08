class DishesController < ApplicationController
  before_action :set_dish, only: %i(show edit update destroy)

  def show
    @comment = Comment.new
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
  end

  def update
    if @dish.update_attributes(dish_params)
      flash[:success] = "料理情報が更新されました！"
      redirect_to dish_path(@dish)
    else
      render 'edit'
    end
  end

  def destroy
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
      params.require(:dish).permit(:name, :description, :portion, :tips, :picture, :required_time, ingredients_attributes: [:id, :name, :quantity]).merge(user_id: current_user.id)
    end

    def set_dish
      @dish = Dish.find(params[:id])
    end
end
