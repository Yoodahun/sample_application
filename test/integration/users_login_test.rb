require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael) # fixture의 user를 참조함.
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: ""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: @user.email, password: 'password' }}
    assert_redirected_to @user
    follow_redirect! #리다이렉트를 한 것이 올바르게 한 건지 체크함.
    assert_template 'users/show'
    assert_select "a[herf=?]", login_path, count: 0
    # assert_select "a[herf=?]", logout_path
    # assert_select "a[herf=?]", user_path(@user)
    #
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    delete logout_path
    follow_redirect!
    # assert_select "a[herf=?]", login_path
    assert_select "a[herf=?]", logout_path, count: 0
    assert_select "a[herf=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    delete logout_path
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end


end
