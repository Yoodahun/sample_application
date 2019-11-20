class UsersController < ApplicationController
  #edit와 update를 실행하기 전에 logged_in_user를 실행함. 액션명은 해시로 부여.
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy


  def index
    @users = User.paginate(page: params[:page])
  end

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

  def edit #정보수정 페이지로 이동

  end

  def update #실제 정보 수정 처리
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user #show
    else
      render 'edit'
    end

  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
  end

  def logged_in_user #유저가 로그인했는지를 확인. 하지 않았으면 로그인해달라는 메세지 출력
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user #올바른 유저인지 확인
   @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user #관리자인지 확인
    redirect_to(root_url) unless current_user.admin?

  end

end
