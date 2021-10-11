class CommentsController < ApplicationController
  def create
    @dish = Dish.find(params[:dish_id])
    @comment = @dish.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@dish.nil? && @comment.save
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to dish_path(@dish)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @dish = @comment.dish
    if current_user.id == @comment.user_id
      @comment.destroy
      flash[:success] = "コメントを削除しました。"
    else
      flash[:danger] = "コメントを削除できません。"
    end
    redirect_to dish_path(@dish)
  end
end
