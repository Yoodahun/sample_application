require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    #@micropost = Micropost.new(content:"Lorem ipsum", user_id: @user.id);
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "User id should be present" do
    @micropost.user_id = nil;
    assert_not @micropost.valid? #유효하지 않으면 OK
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid? #유효하지 않으면 OK
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
    # Micropost.first의 데이터가 most_recent와 같아야함.
    # default_scope를 사용하여 모델에서 정렬순서를 수정해야함.
  end
end
