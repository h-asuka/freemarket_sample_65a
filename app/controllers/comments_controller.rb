class CommentsController < ApplicationController
  include UserSignedIn
  before_action :user_signed_in
  def create
    @comment = Comment.create(comment_params)
    respond_to do |format|
      format.html { redirect_to item_path(@comment.item.id) }
      format.json
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
