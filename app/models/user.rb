class User < ApplicationRecord
  # 컨트롤러 이름은 복수형을 사용하고,
  # 모델 이름은 단수형을 사용하는 Rails의 Convention
  # presence: true > 존재성의 검증
  # length : maximum 50 > 길이의 검증
  #
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  #데이터가 저장되기전 무조건 실행되는 메소드. 모든 문자를 소문자로 변환
  before_save { email.downcase! }
  attr_accessor :remember_token

  #이름
  validates :name, presence: true, length: { maximum: 50}
  #이메일
  validates :email, presence: true, length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false } #대소문를 구분안함
  #password
  validates :password, presence: true, length: { minimum: 6}

  has_secure_password

  #넘겨받은 문자열을 해시값으로 변환하여 리턴한다.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Generate random String token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #영속적인 세션을 위해 유저를 데이터베이스에 기록한다.
  def remember
    self.remember_token = User.new_token #remember_token은 일시적인 변수
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 입력받은 token이 digest와 일치하면, true를 리턴한다.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
