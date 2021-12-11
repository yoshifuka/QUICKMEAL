class RecordsController < ApplicationController
  before_action :correct_user, only: :create
  def create
    @dish = Dish.find(params[:dish_id])
    @record = @dish.records.build(content: params[:record][:content])
    if !@dish.nil? && @record.save
      flash[:success] = "クッキングレコードを追加しました！"
    else
      flash[:danger] = "クッキングレコードを投稿できませんでした。"
    end
    List.find(params[:list_id]).destroy unless params[:list_id].nil?
    redirect_to dish_path(@dish)
  end

  def destroy
    @record = Record.find(params[:id])
    @dish = @record.dish
    if current_user == @dish.user
      @record.destroy
      flash[:success] = "クッキングレコードを削除しました"
    end
    redirect_to dish_path(@dish)
  end

  private

    def correct_user
      dish = current_user.dishes.find_by(id: params[:dish_id])
      redirect_to root_path if dish.nil?
    end
end
