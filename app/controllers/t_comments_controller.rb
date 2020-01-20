class TCommentsController < ApplicationController
  def create

    @comment = TComment.create(comment_params)
    respond_to do |format|
      format.html { redirect_to transaction_item_path(@comment.item.id) }
      format.json
    end
  end

  private
  def comment_params
    params.require(:t_comment).permit(:text).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
