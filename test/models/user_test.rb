require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # 각 테스트가 실행되기전 실행되는 메소드
  # has_secure_password를 위해 password와 password_confirmation이라는
  # 가상 속성을 넣어줘야함.
  def setup

    @user = User.new(name: "Example User", email:"user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  # 유효성 검증
  test "should be valid" do
    assert @user.valid?
  end

  # 유저 이름의 존재성 검증.
  # 이름이 존재하지 않기 때문에 assert_not을 사용하면 true가 리턴되어야함.
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  # 유저 이메일의 존재성 검증.
  # 이메일이 존재하지 않기 때문에, assert_not을 이용하면  true가 리턴되어야함.
  # 결과는 false인데, assert_not은 동작의 결과가 false나 nil이면 true를 리턴.
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  #유저 이름의 길이 검증
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #유저 이메일의 길이 검증
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  #이메일의 유효성 포맷 검증
  test "email validation should accept valid addresses" do
    valid_addresss = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.kr alice+bob@baz.cn]

    valid_addresss.each {|valid_address|
      @user.email = valid_address
      #두번째 메세지는 에러메세지
      # @user.valid? 가 true가 나면 false를 발생시킬것.
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    }
  end

  #이메일의 무효성 포맷 검증
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each {|invalid_address|
      @user.email = invalid_address
      #@user.valid?가 false의 경우 true를 리턴할 것임. 트루의 경우 메세지 출력
     assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    }
  end

  #이메일의 유니크성 검증
  # valid? 에서 false가 리턴되어야 테스트 통과
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  #이메일의 소문자 처리 검증
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExamPle.COM"
    @user.email = mixed_case_email
    @user.save
    #expected data, to compare Result
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  #비밀번호의 빈 공백문자 검증
  test "password should be present (non-blank)" do
    @user.password = @user.password_confirmation =
        " " * 6
    assert_not @user.valid?, "#{@user.errors.messages}"
  end

  #비밀번호 최소 문자수 검증
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

end
