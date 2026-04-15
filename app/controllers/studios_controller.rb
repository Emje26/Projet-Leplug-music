class StudiosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_studio, only: :show

  def index
    @studios = Studio.order(rating: :desc)
  end

  def show
    @reviews = @studio.reviews.includes(:user).order(created_at: :desc).limit(20)
    @review  = Review.new
  end

  private

  def set_studio
    @studio = Studio.find(params[:id])
  end
end
