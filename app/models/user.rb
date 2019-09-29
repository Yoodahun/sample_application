class User < ApplicationRecord
  # 컨트롤러 이름은 복수형을 사용하고,
  # 모델 이름은 단수형을 사용하는 Rails의 Convention
  # presence: true > 존재성의 검증
  # length : maximum 50 > 길이의 검증
  #
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  #데이터가 저장되기전 무조건 실행되는 메소드. 모든 문자를 소문자로 변환
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 50}
  validates :email, presence: true, length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false } #대소문를 구분안함

  validates :password, presence: true, length: { minimum: 5}

  has_secure_password

end
