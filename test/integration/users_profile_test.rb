require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name) #Check title tag
    assert_select 'h1', text: @user.name #check h1 tag
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'ul.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    # response.body는 해당 페이지 어딘가에 어떠한 내용이 존재한다는 것임.
    # assert_select는 반드시 어떠한 태그를 찾는지 지정을 해줘야함.
  end

end
