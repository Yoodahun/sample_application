module SessionsHelper

  #  세션에 유저 아이디를 기억시킨다.
  def log_in(user)
    session[:user_id] = user.id
  end

  # 쿠키에 유저 아이디와 remember 토큰을 저장한다.
  def remember(user) # Chapter 9
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  #쿠키를 삭제한다.
  def forget(user) # Chapter 9
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #로그아웃하고 세션을 삭제한다.
  def log_out
    forget(current_user) # 영속적 쿠키를 삭제한다.
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if (user_id = session[:user_id]) #세션에 정보가 있다면
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #쿠키에 정보가 있다면
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token]) #유저가 존재하고 토큰이 확실하다면
        log_in user
        @current_user = user
      end

    end
  end

  # 유저가 로그인해있으면 true, 아니라면 false 리턴
  def logged_in?
    !current_user.nil?
  end

  def redirect_back_or(default)  # 기억한 URL로 리다이렉트
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

   def store_location #접근하려고 하는 URL을 저장 get으로 왔을 때만.
     session[:forwarding_url] = request.original_url if request.get?

   end

end
