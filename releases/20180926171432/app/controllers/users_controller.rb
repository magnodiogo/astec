class UsersController < ApplicationController

  before_filter :load_tipos
  before_filter :set_user, only: [:bloqueia_proposta, :resetar_senha, :bloquear, :editar_avatar, 
                                  :desbloquear, :editar_permissoes, :alterar_calculo]

  def logs
    paginar   = 20
    @logs     = Log.where("created_at::date > ?", Date.today - 60.day).includes(:user).order("id desc").paginate(:page => params[:page])
  end

  def acessar_como
    current_user.update(imobiliaria_id: params[:id])
    redirect_to root_path, notice: "Perfil Alterado com sucesso"
  end

  def bloqueia_proposta
    if current_user.tipo == "A"
      @user.update(bloqueio_proposta: ([nil, false].include?(@user.bloqueio_proposta)))
      redirect_to :back, notice: "Alteração de permissão realizada com sucesso"
    else
      acesso_negado
    end
  end

  def bloquear
    @user.lock_access!
    @user.save!
    redirect_to :back, notice: "Usuário bloqueado com sucesso"
  end

  def desbloquear
    @user.unlock_access!
    @user.save!
    redirect_to :back, notice: "Usuário desbloqueado com sucesso"
  end

  def alterar_calculo
    @user.somente_calculo = ([false, nil].include?(@user.somente_calculo))
    @user.save!
    redirect_to :back, notice: "Usuário alterado com sucesso"
  end

  def index
    @users = User.where(tipo: 'A').order("tipo, name")
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def editar_permissoes
    if request.patch?
      if @user.update(user_params)
        redirect_to editar_permissoes_user_path, notice: 'Usuário atualizado com sucesso.'
      else
        render :action => "editar_permissoes"
      end
    end
  end

  def resetar_senha
    @user.password        = @user.password_confirmation = '123456'
    @user.primeiro_acesso = true
    if @user.save!
      redirect_to :back, notice: "Senha alterada para '123456'"
    else
      redirect_to :back, notice: "Não foi possível alterar o usuário"
    end
  end

  def plano_de_fundo
  end

  def alterar_plano_de_fundo
    if params[:imagem].present?
      path = File.join("#{Rails.public_path}/assets/", 'lock.jpg')
      File.open(path, "wb") { |f| f.write(params[:imagem].read) }
      redirect_to :back, notice: "Imagem enviada com sucesso."
    else
      redirect_to :back, flash: { error: "Imagem inválida."}
    end
  end

  def editar_avatar
    if request.patch?
      if @user.update(avatar_user_params)
        redirect_to :back, notice: t(:updated, name: 'Avatar') 
      else
        render :editar_avatar
      end
    end
  end

  def load_tipos
    @tipos = [['Imobiliária','I'], ['Administração','A']]
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:add_atividade, :edit_atividade, :new_imobiliaria, 
                                   :edit_imobiliaria, :bloqueia_imobiliaria, :master)
    end

    def avatar_user_params
      params.require(:user).permit(:avatar)
    end
end


