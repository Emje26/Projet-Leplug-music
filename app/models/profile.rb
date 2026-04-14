class Profile < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true
end
