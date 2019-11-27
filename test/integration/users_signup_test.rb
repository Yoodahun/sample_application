require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear #메일 발신횟수 초기화
  end


  test "invalid signup information" do
    get signup_path
    # User.count의 결과값이 메소드 실행 전후로 달라지지 않는 것을 확인
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"

      }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "valid signup information with account activation" do
    get signup_path
     assert_difference 'User.count', 1 do
       post users_path, params: { user: {
           name: "Example User",
           email: "user@example.com",
           password: "password",
           password_confirmation: "password"
       }}
     end
    # 발신된 이메일 메세지가 1개인 것을 확인.
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated? #유효화되지 않은 상태에서 로그인한다.
    log_in_as(user)
    assert_not is_logged_in? #false

    #유효화토큰이 올바르지 않을 경우
    get edit_account_activation_path("Invalid token", email:user.email)
    assert_not is_logged_in? #false

    # 토큰은 올바르지만 메일주소가 무효한 경우
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in? #false

    #토큰이 올바른 경우
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated? # true

    follow_redirect! #Post리퀘스트 송신결과를 확인 후 지정된 주소로 리다이렉트
    assert_template 'users/show'
    assert_not flash[:success].blank? #비어있는지확인? not이기 때문에 안비어있다는게 맞다면 성공
    assert is_logged_in?
  end

end
