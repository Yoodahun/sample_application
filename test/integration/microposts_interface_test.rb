require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    #invalid create
    assert_select 'ul.pagination'
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {
          micropost: {
              content: " "
          }
      }
    end
    assert_select 'div#error_explanation'
    #valid Create
    content = "This microposts really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    # 지정파일을 fixture로 업로드
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {
          micropost: {
              content: content,
              picture: picture
          }
      }
    end
    assert assigns(:micropost).picture?
    follow_redirect!
    assert_match content, response.body

    #delete micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)

    end
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0

  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "#{other_user.microposts.count} micropost", response.body
  end

end
