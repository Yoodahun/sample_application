module UsersHelper

  def gravatar_for(user, size: 80)
    # MD5 구조로 해시화. URL에 이 해시화된 정보를 넘겨야함.
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)

    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
