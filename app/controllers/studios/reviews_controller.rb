class Studios::ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    studio = Studio.find(params[:studio_id])
    review = studio.reviews.new(review_params.merge(user: current_user))

    if review.save
      redirect_to studio_path(studio), notice: "Merci pour ton avis."
    else
      redirect_to studio_path(studio), alert: review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
