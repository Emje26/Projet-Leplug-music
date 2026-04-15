class Studio < ApplicationRecord
  CATEGORIES = %w[studio mixage mastering clip pochette prod cours].freeze

  belongs_to :user
  has_many :bookings, as: :bookable, dependent: :destroy
  has_many :reviews,  as: :reviewable, dependent: :destroy

  validates :name, presence: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

  scope :in_city,       ->(c)   { where("lower(city) = ?", c.to_s.downcase) if c.present? }
  scope :with_category, ->(cat) { where(category: cat) if cat.present? }
  scope :search,        ->(q)   { where("name ILIKE :q OR description ILIKE :q OR city ILIKE :q", q: "%#{q}%") if q.present? }

  def initials
    name.to_s.split(/\s+/).map(&:first).first(2).join.upcase.presence || "LP"
  end

  def display_price
    return nil unless price_per_hour
    "€#{price_per_hour.to_i}/H"
  end
end
