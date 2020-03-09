class UsersController < ApplicationController
  #edit와 update를 실행하기 전에 logged_in_user를 실행함. 액션명은 해시로 부여.
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy


  def index
    @users = User.where(activated: true).paginate(page: params[:page]).order('created_at DESC')
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
  end


  def correct_user #올바른 유저인지 확인
   @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user #관리자인지 확인
    redirect_to(root_url) unless current_user.admin?

  end

end
