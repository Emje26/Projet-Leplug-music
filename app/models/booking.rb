class Booking < ApplicationRecord
  SERVICE_FEE_RATE = 0.15
  STATUSES         = %w[pending confirmed completed cancelled].freeze

  belongs_to :user
  belongs_to :bookable, polymorphic: true

  validates :status, inclusion: { in: STATUSES }
  validates :date, :duration_hours, presence: true
  validates :duration_hours, numericality: { greater_than: 0 }

  before_validation :compute_totals

  def hourly_price
    case bookable
    when Studio then bookable.price_per_hour
    when Talent then bookable.hourly_rate
    end.to_d
  end

  def bookable_label
    case bookable
    when Studio then "STUDIO"
    when Talent then "TALENT"
    else "BOOKING"
    end
  end

  private

  def compute_totals
    return unless duration_hours && hourly_price && hourly_price > 0
    self.subtotal    = (BigDecimal(duration_hours.to_s) * hourly_price).round(2)
    self.service_fee = (subtotal * BigDecimal(SERVICE_FEE_RATE.to_s)).round(2)
    self.total       = (subtotal + service_fee).round(2)
  end
end
