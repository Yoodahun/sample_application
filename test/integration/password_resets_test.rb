require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path # go to the edit page
    assert_template 'password_resets/new'

    #무효한 메일 주소
    post password_resets_path, params: { password_reset: {
        email: ""
    }}
    assert_not flash.empty? #is it empty? false > true
    assert_template 'password_resets/new'

    # 유효한 메일 주소
    post password_resets_path, params: { password_reset: {
        email: @user.email
    }}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest # is it not eqaul? True > True
    assert_equal 1, ActionMailer::Base.deliveries.size # Success send the mail
    assert_not flash.empty?  #is it empty? false > true (This is Success Case)
    assert_redirected_to root_url

    #invalid Form Test
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    #invalid user test
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    #valid user mail address but invalid token
    get edit_password_reset_path('worng token', email: user.email)
    assert_redirected_to root_url

    # valind user mail and token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # invalid password and password confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
          password: "foobaz",
          password_confirmation: "barguux"
      }
    }
    assert_select 'div#error_explanation' # Is there Error box?

    #valid password and password confirmation
    patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: { password: "foobaz",
                password_confirmation: "foobaz"
        }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_nil user.reload.reset_digest
    assert_redirected_to user

  end

  test "Expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: {
        email: @user.email
    }}
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), params: {
        email: @user.email,
        user: {
            password: "foobar",
            password_confirmation: "foobar"
        }
    }

    assert_response :redirect
    follow_redirect!
    assert_match /Password reset has expired./i, response.body

  end
end
