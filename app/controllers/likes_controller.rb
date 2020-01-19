class LikesController < ApplicationController
  include UserSignedIn
  before_action :user_signed_in
  def create
    @item = Item.find(params[:item_id])
    @item.increment!(:likes_count, 1)
    @like = Like.create(user_id: current_user.id, item_id: params[:item_id])
    @likes = Like.where(item_id: params[:item_id])
  end


  def destroy
    @item = Item.find(params[:item_id])
    @item.decrement!(:likes_count, 1)
    @like = Like.find_by(user_id: current_user.id, item_id: params[:item_id])
    @like.destroy
    @likes = Like.where(item_id: params[:item_id])
  end
end
