Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "home#index"

  # Assistant chatbot
  get  "assistant",        to: "assistant#show",  as: :assistant
  post "assistant/talk",   to: "assistant#talk",  as: :assistant_talk
  post "assistant/reset",  to: "assistant#reset", as: :reset_chat
  post "assistant/save",   to: "assistant#save",  as: :assistant_save

  resource :profile, only: [:show, :edit, :update]
  get 'profile/settings', to: 'profiles#settings', as: :profile_settings
  get 'who_you_are', to: 'profiles#edit', as: :who_you_are

  post 'meal_plans/generate', to: 'meal_plans#generate', as: :meal_plans_generate

  resources :recipes, only: [:index, :show, :destroy, :new, :create]

  # Chat
  resources :chats, only: [:index]

  get "planner", to: "pages#planner"

  get "up" => "rails/health#show", as: :rails_health_check
end
