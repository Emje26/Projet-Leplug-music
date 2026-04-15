class Review < ApplicationRecord
  belongs_to :user
  belongs_to :reviewable, polymorphic: true, counter_cache: :reviews_count

  validates :rating, inclusion: { in: 1..5 }
  validates :content, length: { maximum: 1000 }, allow_blank: true

  after_save    :refresh_reviewable_rating
  after_destroy :refresh_reviewable_rating

  private

  def refresh_reviewable_rating
    avg = reviewable.reviews.average(:rating).to_f.round(2)
    reviewable.update_column(:rating, avg)
  end
end
