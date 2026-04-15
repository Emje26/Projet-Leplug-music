class HomeController < ApplicationController
  # No before_action — logged-out users hit the landing.

  def index
    # Dispatch: logged-in users go straight to the marketplace search.
    if user_signed_in?
      redirect_to search_path and return
    end
    # Else: render the landing page (app/views/home/index.html.erb).
  end

  # Secondary tab — the old logged-in feed. Still accessible via
  # /feed for users who want to browse the social timeline.
  def feed
    authenticate_user!
  end
end
