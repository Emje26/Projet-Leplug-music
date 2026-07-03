class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy

  # Marketplace
  has_one  :studio,   dependent: :destroy
  has_one  :talent,   dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews,  dependent: :destroy

  # Crée automatiquement un profil après l'inscription
  after_create :create_default_profile

  private

  def create_default_profile
    create_profile unless profile
  end
end
