# The User model is a devise model that has the following modules: database_authenticatable,
# registerable, recoverable, rememberable, and validatable

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :articles

  scope :articles, -> { where(:active => true)}
  # Ex:- scope :active, -> {where(:active => true)}
end
