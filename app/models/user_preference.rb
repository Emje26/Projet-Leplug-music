class UserPreference < ApplicationRecord
  belongs_to :user

  serialize :allergies, coder: JSON

  validates :age, numericality: { greater_than: 0, less_than: 120 }, allow_nil: true
  validates :gender, inclusion: { in: %w[male female other] }, allow_nil: true
  validates :activity_level, inclusion: { in: %w[sedentary light moderate active very_active] }, allow_nil: true
  validates :weekly_budget_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :max_prep_time_minutes, numericality: { greater_than: 0 }, allow_nil: true

  ACTIVITY_MULTIPLIERS = {
    'sedentary' => 1.2,
    'light' => 1.375,
    'moderate' => 1.55,
    'active' => 1.725,
    'very_active' => 1.9
  }.freeze

  # Calculate recommended daily calories using Mifflin-St Jeor equation
  def calculate_recommended_kcal
    return 2000 unless age.present? && gender.present?

    # Base Metabolic Rate (BMR) - using average weight/height
    if gender == 'male'
      bmr = 10 * 75 + 6.25 * 175 - 5 * age + 5
    else
      bmr = 10 * 60 + 6.25 * 165 - 5 * age - 161
    end

    multiplier = ACTIVITY_MULTIPLIERS[activity_level] || 1.55
    (bmr * multiplier).round
  end

  def allergies
    super || []
  end

  def allergies=(value)
    super(value.is_a?(Array) ? value : value.to_s.split(',').map(&:strip))
  end
end
