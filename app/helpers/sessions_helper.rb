module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user) # Chapter 9
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user) # Chapter 9
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user) # 영속적 쿠키를 삭제한다.
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    if (user_id = session[:user_id]) #세션에 정보가 있다면
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #쿠키에 정보가 있다면
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token]) #유저가 존재하고 토큰이 확실하다면
        log_in user
        @current_user = user
      end

    end
  end

  # 유저가 로그인해있으면 true, 아니라면 false 리턴
  def logged_in?
    !current_user.nil?
  end

end
