class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :verifica_primeiro_acesso
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Requere Authorize CanCan ( model/ability.rb )
  authorize_resource :unless => :no_check_authorized?
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Rescue AccessDenied for CanCan ( model/ability.rb )
  #   call accesso_negado method
  rescue_from CanCan::AccessDenied do |exception|
    acesso_negado
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    invalid_token
  end

  def invalid_token
    redirect_to root_path, flash: { error: "Invalid Token" }
    return
  end
  # Redirecto to root_url with flash error message
  def acesso_negado
    redirect_to root_path, flash: { error: t(:access_denied) }
    return
  end

  # Alternative method for controllers ignored by no_check_authorized?
  def authorize_ability(resource)
    acesso_negado if cannot? action_name.to_sym, resource
  end

  def get_namespace
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_name_segments.join('/').camelize
  end

  protected
    def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation, :current_password, :name, :imobiliaria_id]
      devise_parameter_sanitizer.permit :sign_up,        keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
      #devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :roles) }
      #devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :password) }
      #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :language, :password, :password_confirmation, :current_password) }
    end

  private
    #   Private
    # CanCan: Ignore controllers without model
    def no_check_authorized?
      logger.info controller_name
      ['sessions', 'confirmations', 'home', 'registrations', 'passwords', 'emailer', 'ds_logradouros'].include? controller_name
    end

    def current_ability
      # I am sure there is a slicker way to capture the controller namespace
      controller_namespace = get_namespace
      Ability.new(current_user, controller_namespace)
    end

    def user_not_authorized
      redirect_to(root_path, flash: { error: t("devise.failure.unauthenticated")})
    end
    
    def verifica_primeiro_acesso
      if current_user and current_user.primeiro_acesso and controller_name != 'registrations' and controller_name != 'sessions' 
        redirect_to edit_user_registration_path, flash: { error: "Atualize sua senha antes de utilizar o sistema" }
        return
      end 
    end
end


