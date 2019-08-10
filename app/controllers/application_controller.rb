class ApplicationController < ActionController::
  # protect_from_forgery with: :exception

  def hello
    render html: "hello, world!"
  end
end
