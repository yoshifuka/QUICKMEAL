class RecordsController < ApplicationController
  before_action :correct_user, only: :create
  def create
    @dish = Dish.find(params[:dish_id])
    @record = @dish.records.build(content: params[:record][:content])
    if !@dish.nil? && @record.save
      flash[:success] = "クックレコードを追加しました！"
    else
      flash[:danger] = "クックレコードを投稿できませんでした。"
    end
    redirect_to dish_path(@dish)
  end

  def destroy
    @record = Record.find(params[:id])
    @dish = @record.dish
    if current_user == @dish.user
      @record.destroy
      flash[:success] = "クックレコードを削除しました"
    end
    redirect_to dish_path(@dish)
  end

  private
    def correct_user
      dish = current_user.dishes.find_by(id: params[:dish_id])
      redirect_to root_path if dish.nil?
    end
end
