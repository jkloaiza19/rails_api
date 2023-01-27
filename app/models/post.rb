# A post belongs to a user, has many attached images, and validates the presence of a caption and
# allow_comments
class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :caption, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 250 }
  validates :allow_comments, presence: true, default: true
  validates :show_likes_count, presence: true, default: true
end
