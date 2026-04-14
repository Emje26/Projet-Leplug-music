class PagesController < ApplicationController
  before_action :authenticate_user!

  def planner
    @user_preference = UserPreference.last || UserPreference.new
    @meal_plan = MealPlan.current_for(current_user)
  end
end
