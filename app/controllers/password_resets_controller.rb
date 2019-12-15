class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] #패스워드 재설정의 유효기간이 남아있는가

  def new
  end

  def create
    # Search User by Email
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user #if there is user
      @user.create_reset_digest #create digest
      @user.send_password_reset_email #sent email

      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'

    end

  end

  def edit
  end

  def update
    if params[:user][:password].empty?      #새로운 패스워드가 빈 문자열인가
      @user.errors.add(:password, :blank) #빈 문자열일 때 오브젝트에 에러메세지를 추가한다.
       render 'edit'
    elsif @user.update_attributes(user_params) #올바른 패스워드라면 갱신한다.
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' #무효한 패스워드이기 때문에 실패처리한다.

    end

  end


  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user  # 유효한 유저인지 확인한다.
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url

      end
    end

    def check_expiration # 토큰이 유효기한 확인
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired"
        redirect_to new_password_reset_url
      end


    end


end
