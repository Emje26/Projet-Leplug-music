class ApplicationController < ActionController::Base
  # before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Après connexion → Home page
  def after_sign_in_path_for(resource)
    root_path
  end

  # Après inscription → Compléter le profil
  def after_sign_up_path_for(resource)
    who_you_are_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
