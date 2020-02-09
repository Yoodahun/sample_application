class Micropost < ApplicationRecord
  belongs_to :user #Belongs to User model. because of user:reference
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  default_scope -> { order(created_at: :desc) } #Desc database search result

  mount_uploader :picture, PictureUploader #model, uploaderClass
  validate :picture_size

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
