class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    alias_action :index, :show, :new, :create, :edit, :update, :destroy, to: :crud
    alias_action :new, :create, to: :make
    alias_action :edit, :update, to: :change

    cannot :crud, :all

    @user ||= user     
    @user ||= User.new # guest @user (not logged in)

    if @user.tipo == "A" and @user.imobiliaria_id.nil?
      administrador
    elsif controller_namespace != 'Admin'
      usuario
      if @user.tipo == "A"
        can [:acessar_como], User
      end
    end

    if @user.add_atividade
      can [:crud], Atividade
    end
    if controller_namespace == ""
      can    :index,             Atividade
    end
    cannot :editar_permissoes, User, tipo: 'I'
    can    [:edit, :update],   :registrations
    can    :consultar,         Atividade
    can    :calcula_premio,    Seguro
    can    :site, :home
  end

  def administrador
    can [:admin, :crud], [Arquivo, Atividade, Corretora, Documento, Faq, Imobiliaria, Logradouro, User, Faq, Mensagem, Titulo, SeguroFianca]
    can [:read, :make, :edit_account, :update_account], :registrations
    can [:coberturas_pendentes, :relatorios, :renovacoes, :gerar_renovacoes], Seguro
    can [:relatorios, :alterar_pagamento], Titulo
    can [:alterar_pagamento], SeguroFianca
    can [:usuarios],   Imobiliaria
    can [:logs],       User
    can [:acessar_como], User

    if @user.master
      can [:crud],        Corretora
      can :block_unblock, Imobiliaria
      can [:bloqueia_proposta, :bloquear,  :desbloquear],       User
      can [:alterar_plano_de_fundo, :plano_de_fundo],           User
      can [:resetar_senha, :editar_permissoes],                 User
      can [:alterar_calculo, :editar_avatar],                   User
    else
      cannot [:destroy], [Arquivo, Atividade, Corretora, Documento, Faq, Imobiliaria, Logradouro, Seguro, Titulo, User, SeguroFianca]
    end

=begin
    # CANNOT
    if !@user.new_imobiliaria
      cannot [:make], Imobiliaria
    end
    if !@user.edit_imobiliaria
      cannot [:change], Imobiliaria
    end
    if !@user.bloqueia_imobiliaria
      cannot [:block_unblock], Imobiliaria
    end
    if !@user.add_atividade
      cannot [:crud], Atividade
    end
=end
  end

  def usuario
    if @user.somente_calculo
      can [:calculadora], Seguro
    else
      if @user.master
        can :desfazer_transmitir, Seguro do |s|; [1,2].include?(s.status) and @user.imobiliaria_id == s.imobiliaria_id; end
        can :change, Seguro, imobiliaria_id: @user.imobiliaria_id
      end
      can [:crud, :load_locatarios], SeguroFianca
      can [:crud],      Titulo
      can [:index, :make, :empresarial, :residencial], Seguro
      can :transmitir,                Seguro do |s|; [0].include?(s.status)   and @user.imobiliaria_id == s.imobiliaria_id and !@user.bloqueio_proposta; end
      can :gerar_pdf,                 Seguro do |s|; [1,2].include?(s.status) and @user.imobiliaria_id == s.imobiliaria_id; end
      can [:change, :show, :destroy], Seguro do |s|; [0,3].include?(s.status) and @user.imobiliaria_id == s.imobiliaria_id; end

      can :search_cep, Logradouro
      can :teamviewer, :home
    end
    can :index,  Faq
    can [:formulario], Emailer
  end
end
