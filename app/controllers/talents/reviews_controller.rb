class Talents::ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    talent = Talent.find(params[:talent_id])
    review = talent.reviews.new(review_params.merge(user: current_user))

    if review.save
      redirect_to talent_path(talent), notice: "Merci pour ton avis."
    else
      redirect_to talent_path(talent), alert: review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
