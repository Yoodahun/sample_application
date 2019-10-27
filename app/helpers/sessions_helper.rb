module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    if session[:user_id]
        # 세션에 유저정보가 있다면, 해당 정보를 이용하여 데이터베이스에서 조회한다.
        @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # 유저가 로그인해있으면 true, 아니라면 false 리턴
  def logged_in?
    !current_user.nil?
  end

end
