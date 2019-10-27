class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user #프로필 페이지로 리다이렉트
    else
      render 'new'
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
  end

end
