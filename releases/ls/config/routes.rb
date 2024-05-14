Rails.application.routes.draw do
  #
  devise_for :users, skip: [:passwords, :unlocks]
  devise_scope :user do
    get   'users',                       to: 'users#index',                         as: 'users'
    get   'users/logs',                  to: 'users#logs',                          as: 'logs_users'
    get   'users/acessar_como',          to: 'users#acessar_como',                  as: 'acessar_como_users'
    get   'users/plano_de_fundo',        to: 'users#plano_de_fundo',                as: 'plano_de_fundo_users'
    get   'users/:id/editar_avatar',     to: 'users#editar_avatar',                 as: 'editar_avatar_user'
    patch 'users/:id/editar_avatar',     to: 'users#editar_avatar'
    post  'users/alterar_plano_de_fundo',to: 'users#alterar_plano_de_fundo',        as: 'alterar_plano_de_fundo_users'
    get   'users/:id/bloqueia_proposta', to: 'users#bloqueia_proposta',             as: 'bloqueia_proposta_user'
    get   'users/:id/resetar_senha',     to: 'users#resetar_senha',                 as: 'resetar_senha_user'
    get   'users/:id/bloquear',          to: 'users#bloquear',                      as: 'bloquear_user'
    get   'users/:id/desbloquear',       to: 'users#desbloquear',                   as: 'desbloquear_user'
    get   'users/:id/editar_permissoes', to: 'users#editar_permissoes',             as: 'editar_permissoes_user'
    patch 'users/:id/editar_permissoes', to: 'users#editar_permissoes'
    get   'users/:id/alterar_calculo',   to: 'users#alterar_calculo',               as: 'alterar_calculo_user'
    #
    patch 'users/update_account/:id',    to: 'devise/registrations#update_account', as: 'update_account_usuario_registration'
    get   'users/:id/edit_account',      to: 'devise/registrations#edit_account',   as: 'edit_account_usuario_registration'
    get   'users/sign_up/:id',           to: 'devise/registrations#new',            as: 'new_imob_usuario_registration'

    authenticated :user do
      root to: 'home#index', as: "index_home"
    end
    
    unauthenticated :user do
      root to: 'home#site', as: "site_home"
    end
  end
  root "home#index"
   
  # HOME
  #get "home#index"
  #get "home#site"

  namespace :admin do
    resources :atividades, except: [:destroy] do
      collection do
        get  :busca_atividades
        post :busca_atividades
      end
    end
    resources :imobiliarias do
      resources :documentos, only: [:index, :new, :create, :destroy]
      collection do 
        get :documentos
      end
      member do
        get :block_unblock, :usuarios 
      end
    end
    resources :seguros do
      collection do
        get  :coberturas_pendentes, :relatorios, :renovacoes
        post :relatorios, :renovacoes, :gerar_renovacoes
      end
    end
    resources :seguros_fiancas, only: [:index, :destroy, :show] do
      collection do
        get  :relatorios
        post :relatorios
      end
      member do
        get :alterar_pagamento
      end
    end
    resources :titulos, only: [:index, :destroy, :show] do
      collection do
        get :relatorios
        post :relatorios
      end
      member do
        get :alterar_pagamento
      end
    end
    #
    resources :arquivos,    except: [:destroy]
    resources :corretoras,  except: [:destroy]
    resources :faqs
    resources :logradouros
    resources :mensagens
  end

  namespace :dynamic_select do
    get ':estado_id/ds_logradouros',  to: 'ds_logradouros#index', as: 'ds_logradouros'
    #get ':team_id/ds_matches',        to: 'ds_matches#index', as: 'ds_matches'
    #get ':scope_id/ds_scope_systems', to: 'ds_scope_systems#index', as: 'ds_scope_systems'
  end
  
  #resources :admin do 
  #  collection do
  #    get  :index_relatorios, :index_titulos              # :coberturas_pendentes, :gerador_de_arquivos, :alterar_plano_de_fundo
  #    post :relatorios, :titulos, :enviar_plano_de_fundo  # :gerador_de_arquivos
  #  end
  #end

  resources :atividades, only: :index do
    collection do
      get :consultar
    end
  end
  resources :faqs,       only: :index
  #resources :fiancas
  resources :titulos
  resources :seguros_fiancas do 
    collection do
      get :load_locatarios
    end
  end

  resources :logradouros do
    collection do
      get  :busca_endereco_por_cep, :busca_endereco_fianca, :get_cidades, :search_cep, :titulo_search_cep #, :get_bairros
      post :busca_endereco_por_cep, :busca_endereco_fianca, :get_cidades, :search_cep, :titulo_search_cep # :get_bairros
    end
  end
 
  resources :seguros do
    collection do
      get  :residencial, :empresarial, :calcula_premio
      post :calcula_premio
      get  :calculadora
      #get  :inicio, :faqs, :calcula_premio, :transmitir, :desfazer_transmitir, :data_limite
      #post :calcula_premio, :gerar_renovacoes, :consultar_renovacoes
    end
    member do
      get :transmitir, :desfazer_transmitir, :gerar_pdf
    end
  end

  resources :emailer, only: [] do
    collection do
      get  :formulario, :coberturas_pendentes
      post :formulario
    end
  end

  #resources 'renovacoes', :controller => 'seguros', :action => 'renovacoes'

end
