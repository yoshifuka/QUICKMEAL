class DishesController < ApplicationController
  before_action :set_dish, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  def index
  end

  def show
    @comment = Comment.new
    @record = Record.new
  end

  def new
    @dish = Dish.new
    10.times { @dish.ingredients.build }
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
    if @dish.update(dish_params)
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
    end
  end

  private

    def dish_params
      params.require(:dish).permit(:name, :description, :portion, :tips,
                                   :way_of_cooking,
                                   :picture, :required_time,
                                   ingredients_attributes:
                                   [:id, :name, :quantity]).merge(user_id: current_user.id)
    end

    def set_dish
      @dish = Dish.find(params[:id])
    end

    def correct_user
      @dish = current_user.dishes.find_by(id: params[:id])
      redirect_to root_path if @dish.nil?
    end
end
