class TalentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_talent, only: :show

  def index
    @talents = Talent.available.order(rating: :desc)
  end

  def show
    @reviews = @talent.reviews.includes(:user).order(created_at: :desc).limit(20)
    @review  = Review.new
  end

  private

  def set_talent
    @talent = Talent.find(params[:id])
  end
end
