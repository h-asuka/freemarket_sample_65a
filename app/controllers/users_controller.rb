class UsersController < ApplicationController
  # before_action :move_to_index, only: [:mypage]
  before_action :set_number, only: [:tell_update]
  before_action :set_address, only: [:address_update]
  
  include SetUser 
  include SetUser 
  before_action :set_user, except: [:new]

  before_action :Guard_clause
  before_action :user_confirmation, only: [:update]
  
  def show
    @user = User.find(params[:id])
  end
  
  
  def edit
    @number = @user.number
    @address = @user.address
      render "users/edit/#{params[:name]}" 
    end
  end

  # プロフィール更新
  def update
   if @user.update(user_params)
      flash[:notice] = "変更を保存しました"
      redirect_to "/users/mypage/mypage/#{current_user.id}"
    else
      flash[:alert] = "編集の保存に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end


  def mypage
    render "users/mypage/#{params[:name]}" 
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction,:avatar_image)
  end

  def Guard_clause
    if @user.id != current_user.id
      flash[:alert]= 'ユーザーが違います'
      redirect_to root_path
    end
  end

end
