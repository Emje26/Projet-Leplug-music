class Talent < ApplicationRecord
  SPECIALTIES = %w[beatmaker mixeur mastering videaste graphiste prod coach].freeze

  belongs_to :user
  has_many :bookings, as: :bookable, dependent: :destroy
  has_many :reviews,  as: :reviewable, dependent: :destroy

  validates :name, presence: true
  validates :specialty, inclusion: { in: SPECIALTIES }, allow_blank: true

  scope :available,      -> { where(available: true) }
  scope :with_specialty, ->(s) { where(specialty: s) if s.present? }
  scope :in_city,        ->(c) { where("lower(city) = ?", c.to_s.downcase) if c.present? }
  scope :search,         ->(q) { where("name ILIKE :q OR description ILIKE :q OR specialty ILIKE :q", q: "%#{q}%") if q.present? }

  def initials
    name.to_s.split(/\s+/).map(&:first).first(2).join.upcase.presence || "LP"
  end

  def display_price
    return nil unless hourly_rate
    "€#{hourly_rate.to_i}/H"
  end
end
