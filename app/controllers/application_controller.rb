class ApplicationController < ActionController::Base
  include SessionsHelper # SessionHelper의 log_in 메소드를 다른 컨트롤러에서도 사용하기 위해서 컨트롤러에서 읽어들임.

  def hello
    render html: "hello world!"

  end

  private

    def logged_in_user #유저가 로그인했는지를 확인. 하지 않았으면 로그인해달라는 메세지 출력
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
