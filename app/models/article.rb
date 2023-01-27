# An Article has a title, content, and slug, and the slug must be unique.
class Article < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :slug, presence: true, uniqueness: true
    
    scope :recent, -> { order(created_at: :desc) }
end
