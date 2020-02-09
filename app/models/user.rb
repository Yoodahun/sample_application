class User < ApplicationRecord
  # 컨트롤러 이름은 복수형을 사용하고,
  # 모델 이름은 단수형을 사용하는 Rails의 Convention
  # presence: true > 존재성의 검증
  # length : maximum 50 > 길이의 검증
  #
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_many :microposts, dependent: :destroy
  # micropost Relationship. when user deleted, related posts also delete.

  #데이터가 저장되기전 무조건 실행되는 메소드. 모든 문자를 소문자로 변환
  before_save :downcase_email
  #User오브젝트가 생성되기 전 실행되는 메소드
  before_create :create_activation_digest
  #User모델의 가상의 속성
  attr_accessor :remember_token, :activation_token, :reset_token

  #이름
  validates :name, presence: true, length: { maximum: 50}
  #이메일
  validates :email, presence: true, length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false } #대소문를 구분안함
  #password
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true
  #수정 시의 패스워드 공백을 허용함.

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
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  def forget
    update_attribute(:remember_digest, nil)
  end

  # account를 유효화한다.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Send mail
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #create password reset digest
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)

  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # check the password expire.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  private
  # convert email address to downcase
  def downcase_email
    self.email = email.downcase
  end

  # create activation token and digest then insert.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
