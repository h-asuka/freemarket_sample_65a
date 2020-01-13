class UsersController < ApplicationController
  include SetUser 
  before_action :set_user, except: [:new]
  
  def show
  end

  
  def edit
    @number = @user.number
    @address = @user.address
    if @user.id == current_user.id
      render "users/edit/#{params[:name]}" 
    else
      redirect_to root_path
    end
  end

  # プロフィール更新
  def update
     @user.update(user_params)
     redirect_to root_path
  end
  

  def mypage
    if @user.id == current_user.id
      render "users/mypage/#{params[:name]}" 
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction)
  end
end
