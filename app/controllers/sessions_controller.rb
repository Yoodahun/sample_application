class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #유저 오브젝트가 존재하면서, 유저의 패스워드가 올바를 때.
      # 유저 로그인 후 유저 정보 페이지로 리다이렉트
      log_in(user)
      redirect_to(user)
    else
      #유저 로그인 실패 후 에러메세지 작성
      flash.now[:danger] = "Invalid email/password combination"
      # flash.now는 렌더링이 끝난 페이지에서도 표시가 가능하며, 페이지를 이동하면 사라지게됨.
      render 'new'
    end

  end

  def destroy
    log_out
    redirect_to root_path

  end
end
