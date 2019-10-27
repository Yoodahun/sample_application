require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

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

  test "valid signup information" do
    get signup_path
     assert_difference 'User.count', 1 do
       post users_path, params: { user: {
           name: "Example User",
           email: "user@example.com",
           password: "password",
           password_confirmation: "password"
       }}
     end
    follow_redirect! #Post리퀘스트 송신결과를 확인 후 지정된 주소로 리다이렉트
    assert_template 'users/show'
    assert_not flash[:success].blank? #비어있는지확인? not이기 때문에 안비어있다는게 맞다면 성공
    assert is_logged_in?
  end

end
