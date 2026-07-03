Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "home#index"

  # ---- HOME / FEED --------------------------------------------------
  # home#index dispatche : logged-in → redirect search_path, logged-out → landing.
  # Le feed (ancien home logged-in) devient un onglet secondaire.
  get "feed",   to: "home#feed",   as: :feed
  get "player", to: "home#player", as: :player

  # ---- SEARCH / MARKETPLACE ----------------------------------------
  get "search",         to: "search#index",   as: :search
  get "search/results", to: "search#results", as: :search_results

  resources :studios, only: [:index, :show] do
    resources :reviews, only: [:create], module: :studios
  end

  resources :talents, only: [:index, :show] do
    resources :reviews, only: [:create], module: :talents
  end

  # ---- BOOKING FLOW -------------------------------------------------
  # new attend ?bookable_type=Studio&bookable_id=:id
  resources :bookings, only: [:new, :create, :show, :index]

  # ---- ASSISTANT (PLUG/AI) ------------------------------------------
  get  "assistant",        to: "assistant#show",  as: :assistant
  post "assistant/talk",   to: "assistant#talk",  as: :assistant_talk
  post "assistant/reset",  to: "assistant#reset", as: :reset_chat

  # ---- PROFILE (inchangé) ------------------------------------------
  resource :profile, only: [:show, :edit, :update]
  get 'profile/settings', to: 'profiles#settings', as: :profile_settings
  get 'profile/revenues', to: 'profiles#revenues', as: :profile_revenues
  get 'who_you_are',      to: 'profiles#edit',     as: :who_you_are

  # ---- CHAT + CONVERSATIONS -----------------------------------------
  resources :chats, only: [:index]
  resources :conversations, only: [:show]

  # ---- SETTINGS (money dashboard) ------------------------------------
  get "settings/money", to: "settings#money", as: :settings_money

  # ---- HEALTH -------------------------------------------------------
  get "up" => "rails/health#show", as: :rails_health_check
end
