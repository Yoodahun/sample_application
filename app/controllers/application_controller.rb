class ApplicationController < ActionController::Base
  include SessionsHelper # SessionHelper의 log_in 메소드를 다른 컨트롤러에서도 사용하기 위해서 컨트롤러에서 읽어들임.

  def hello
    render html: "hello world!"

  end

end
