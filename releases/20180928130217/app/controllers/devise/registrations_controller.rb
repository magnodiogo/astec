class Devise::RegistrationsController < DeviseController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  #before_action :carregar_roles, :only => [:new, :create]
  #before_action :carregar_roles_edit, :only => [:edit, :edit_account]
  
  # Removendo cancan e add minha checagem
  skip_authorize_resource
  before_action :call_authorize_ability
  layout 'application'
  def call_authorize_ability  
    authorize_ability(:registrations)
  end

  # GET /resource/sign_up
  def new
    @imobiliaria = Imobiliaria.find(params[:id]) if params[:id].present?
    #if entidade and entidade.users.count == 0
    #   build_resource({nome: entidade.nome, email: entidade.email, username: "crdd" + entidade.id.to_s.rjust(4,'0')})
    #else
       build_resource({imobiliaria_id: params[:id]})
    #end
    respond_with self.resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    #if current_user.is?(:admin) and params[:id].present?
    #  resource.imobiliaria_id = Imobiliaria.find(params[:id])
    #else
    #  resource.entidade = current_user.entidade
    #end
    resource.tipo            = (resource.imobiliaria_id ? 'I' : 'A')
    resource.primeiro_acesso = true
    resource.active          = true
    resource.admin_corretora = false

    if resource.save
      resource.active
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        #sign_up(resource_name, resource)
        #respond_with resource, :location => after_sign_up_path_for(resource)
        if resource.imobiliaria? 
          redirect_to usuarios_admin_imobiliaria_path(resource.imobiliaria)
        #elsif current_user.conselho? and resource.despachante?
        #  redirect_to usuarios_despachante_path(resource.entidade)
        else  
          redirect_to users_path
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
  end

  # GET /resource/edit
  def edit_account
    @user  = User.find(params[:id])
    @roles = @user.entidade.class::ROLES
    #render :edit_account
  end

  def update_account
    @user = User.find(params[:id])
    if @user.update(account_update_params)
      redirect_to :back, notice: "Usuário atualizado"
    else
      @roles = @user.entidade.class::ROLES
      render :edit_account
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    #resource.primeiro_acesso = false
    if resource.update(account_update_params.merge(primeiro_acesso: false))
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
      return
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    #devise_parameter_sanitizer.for(:sign_up) 
    params.require(:user).permit(:login, :username, :name, :email, :password, :password_confirmation, :imobiliaria_id) 
  end

  def account_update_params
    # devise_parameter_sanitizer.for(:account_update) 
    params.require(:user).permit(:name, :username, :password, :current_password, :password_confirmation)
  end

  def carregar_roles
    #if current_user.conselho? and params[:id].present?
    #  @roles = Imobiliaria::ROLES
    #elsif current_user.mondrian?
    #  @roles = Conselho::ROLES
    #elsif current_user.conselho? 
    #  @roles = Conselho::ROLES_CRDD
    #else
    #  @roles = Imobiliaria::ROLES
    #end
  end

  def carregar_roles_edit
    #user = User.find(params[:id] || current_user.id)
    #if current_user.mondrian?
    #  @roles = Conselho::ROLES
    #elsif user.conselho?
    #  @roles = Conselho::ROLES_CRDD
    #elsif user.despachante? 
    #  @roles = Imobiliaria::ROLES
    #end
  end
end
