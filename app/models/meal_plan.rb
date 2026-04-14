class MealPlan < ApplicationRecord
  belongs_to :user

  serialize :plan_data, coder: JSON

  validates :user, presence: true
  validates :week_start_date, presence: true

  def self.current_for(user)
    where(user: user)
      .where('week_start_date <= ?', Date.current)
      .order(week_start_date: :desc)
      .first
  end
end
