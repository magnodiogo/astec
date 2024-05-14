# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180913142052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arquivos", force: :cascade do |t|
    t.string   "path",       limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total"
  end

  create_table "atividades", force: :cascade do |t|
    t.string   "codigo",     limit: 255
    t.string   "atividade",  limit: 255
    t.text     "observacao"
    t.boolean  "bloqueado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bairros", force: :cascade do |t|
    t.integer "codigo_correios"
    t.string  "uf",              limit: 2
    t.integer "codigo_cidade"
    t.string  "nome"
    t.string  "nome_abreviado"
  end

  add_index "bairros", ["codigo_correios"], name: "index_bairros_on_codigo_correios", using: :btree

  create_table "ceps", force: :cascade do |t|
    t.string   "cep",        limit: 255
    t.string   "endereco",   limit: 255
    t.string   "bairro",     limit: 255
    t.string   "cidade",     limit: 255
    t.string   "uf",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ceps", ["cep"], name: "index_ceps_on_cep", unique: true, using: :btree

  create_table "corretoras", force: :cascade do |t|
    t.string   "codigo_sucursal",      limit: 255
    t.string   "codigo_corretor",      limit: 255
    t.string   "codigo_colaborador",   limit: 255
    t.string   "codigo_susep",         limit: 255
    t.string   "tipo_de_pessoa",       limit: 255
    t.string   "razao_social",         limit: 255
    t.string   "codigo_da_inspetoria", limit: 255
    t.string   "codigo_do_inspetor",   limit: 255
    t.string   "email_corretor",       limit: 255
    t.string   "ddd_corretor",         limit: 255
    t.string   "telefone_corretor",    limit: 255
    t.float    "iof"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "endereco",             limit: 40
    t.string   "numero",               limit: 6
    t.string   "complemento",          limit: 15
    t.string   "bairro",               limit: 20
    t.string   "cidade",               limit: 40
    t.string   "uf",                   limit: 2
    t.string   "cep",                  limit: 8
  end

  create_table "documentos", force: :cascade do |t|
    t.integer  "imobiliaria_id"
    t.string   "documento_file_name",    limit: 255
    t.string   "documento_content_type", limit: 255
    t.string   "documento_file_size",    limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estados", force: :cascade do |t|
    t.string   "uf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.string   "pergunta",   limit: 255
    t.text     "resposta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fiancas", force: :cascade do |t|
    t.string   "locatario_nome"
    t.string   "locatario_sexo"
    t.string   "locatario_cpf"
    t.string   "locatario_rg"
    t.string   "locatario_orgao_expedidor"
    t.date     "locatario_data_expedicao"
    t.string   "locatario_nacionalidade"
    t.date     "locatario_nascimento"
    t.string   "locatario_estado_civil"
    t.string   "locatario_mae"
    t.string   "locatario_pai"
    t.boolean  "locatario_residira_no_imovel"
    t.boolean  "locatario_compora_renda"
    t.boolean  "locatario_correntista"
    t.string   "locatario_segmoneto"
    t.string   "locatario_email_primario"
    t.string   "locatario_email_secundario"
    t.string   "imovel_tipo"
    t.string   "imovel_cep"
    t.string   "imovel_numero"
    t.string   "imovel_complemento"
    t.string   "imovel_administradora"
    t.float    "imovel_aluguel"
    t.float    "imovel_iptu"
    t.float    "imovel_condominio"
    t.float    "imovel_agua"
    t.float    "imovel_luz"
    t.float    "imovel_gas_canalizado"
    t.float    "imovel_danos"
    t.float    "imovel_multa_recisao"
    t.float    "imovel_pintura_interna"
    t.float    "imovel_puntura_externa"
    t.string   "residencia_tipo"
    t.integer  "residencia_tempo_ano"
    t.integer  "residencia_tempo_mes"
    t.string   "residencia_cep"
    t.string   "residencia_numero"
    t.string   "residencia_complemento"
    t.string   "residencia_ddd_fixo"
    t.string   "residencia_telefone_fixo"
    t.string   "residencia_ddd_celular"
    t.string   "residencia_celular"
    t.string   "residencia_nome_proprietario"
    t.string   "residencia_ddd_proprietario"
    t.string   "residencia_telefone_proprietario"
    t.boolean  "residencia_correspondencia"
    t.string   "correspondencia_cep"
    t.string   "correspondencia_numero"
    t.string   "correspondencia_complemento"
    t.string   "anterior_tipo"
    t.integer  "anterior_tempo_ano"
    t.integer  "anterior_tempo_mes"
    t.string   "anterior_cep"
    t.string   "anterior_numero"
    t.string   "anterior_complemento"
    t.string   "anterior_nome_proprietario"
    t.string   "anterior_ddd_proprietario"
    t.string   "anterior_telefone_proprietario"
    t.string   "dependentes_tipo_1"
    t.string   "dependentes_nome_1"
    t.string   "dependentes_nascimento_1"
    t.string   "dependentes_tipo_2"
    t.string   "dependentes_nome_2"
    t.string   "dependentes_nascimento_2"
    t.string   "referencia_bancaria_codigo_banco"
    t.string   "referencia_bancaria_banco"
    t.string   "referencia_bancaria_agencia"
    t.string   "referencia_bancaria_conta"
    t.string   "referencia_bancaria_segmento"
    t.date     "referencia_bancaria_cliente_desde"
    t.string   "cartao_credito_bandeira"
    t.string   "cartao_credito_numero"
    t.date     "cartao_credito_validade"
    t.string   "referencia_comercial_empresa"
    t.string   "referencia_comercial_ddd"
    t.string   "referencia_comercial_telefone"
    t.string   "referencia_comercial_ramal"
    t.string   "referencia_pessoal_nome"
    t.string   "referencia_pessoal_ddd"
    t.string   "referencia_pessoal_telefone"
    t.string   "bens_moveis_tipo"
    t.string   "bens_moveis_fabricante"
    t.string   "bens_moveis_modelo"
    t.string   "bens_moveis_placa"
    t.float    "bens_moveis_valor"
    t.boolean  "bens_moveis_onus"
    t.string   "bens_moveis_instituicao"
    t.integer  "bens_moveis_ano"
    t.boolean  "bens_moveis_seguro"
    t.string   "bens_moveis_seguradora"
    t.string   "bens_imoveis_tipo"
    t.string   "bens_imoveis_cep"
    t.string   "bens_imoveis_numero"
    t.string   "bens_imoveis_complemento"
    t.float    "bens_imoveis_valor"
    t.boolean  "bens_imoveis_onus"
    t.boolean  "bens_imoveis_segura"
    t.string   "bens_imoveis_seguradora"
    t.string   "locatario_ocupacao"
    t.string   "locatario_categoria"
    t.string   "locatario_empresa_nome"
    t.string   "locatario_empresa_ddd"
    t.string   "locatario_empresa_telefone"
    t.string   "locatario_empresa_ramal"
    t.string   "locatario_empresa_cep"
    t.string   "locatario_empresa_numero"
    t.string   "locatario_empresa_complemento"
    t.date     "locatario_empresa_data_admissao"
    t.string   "locatario_empresa_cargo"
    t.float    "locatario_empresa_salario"
    t.string   "locatario_empresa_outras_rendas"
    t.float    "locatario_empresa_valor"
    t.string   "locatario_anterior_nome"
    t.string   "locatario_anterior_ddd"
    t.string   "locatario_anterior_telefone"
    t.string   "locatario_anterior_ramal"
    t.string   "locatario_anterior_cep"
    t.string   "locatario_anterior_numero"
    t.string   "locatario_anterior_complemento"
    t.string   "locatario_anterior_cargo"
    t.float    "locatario_anterior_salario"
    t.string   "locador_nome"
    t.string   "locador_cpf"
    t.string   "locador_email"
    t.float    "locador_renda"
    t.string   "locador_rg"
    t.string   "locador_orgao_expedidor"
    t.date     "locador_data_expedicao"
    t.string   "locador_ddd_fixo"
    t.string   "locador_telefone_fixo"
    t.string   "locador_ddd_celular"
    t.string   "locador_celular"
    t.string   "locador_cep"
    t.string   "locador_numero"
    t.string   "locador_complemento"
    t.integer  "imobiliaria_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imobiliarias", force: :cascade do |t|
    t.string   "nome_fantasia",    limit: 255
    t.string   "estipulante",      limit: 255
    t.string   "tipo_pessoa",      limit: 255
    t.string   "cpf_cnpj",         limit: 255
    t.date     "data_nascimento"
    t.string   "ie_rg",            limit: 255
    t.date     "data_expedicao"
    t.string   "orgao_expeditor",  limit: 255
    t.string   "endereco",         limit: 255
    t.string   "numero",           limit: 255
    t.string   "complemento",      limit: 255
    t.string   "bairro",           limit: 255
    t.string   "cidade",           limit: 255
    t.string   "estado",           limit: 255
    t.string   "telefone",         limit: 255
    t.string   "celular",          limit: 255
    t.string   "contato",          limit: 255
    t.string   "email",            limit: 255
    t.string   "retorno",          limit: 255
    t.string   "operacao",         limit: 255
    t.float    "taxa_residencial"
    t.float    "taxa_empresarial"
    t.boolean  "valor_no_recibo"
    t.string   "pro_laborista",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "bloqueada"
    t.integer  "id_antigo"
  end

  create_table "imobiliarias_mensagens", force: :cascade do |t|
    t.integer "mensagem_id"
    t.integer "imobiliaria_id"
  end

  create_table "localidades", force: :cascade do |t|
    t.integer "codigo_correios"
    t.string  "uf",              limit: 2
    t.string  "nome"
    t.string  "tipo",            limit: 1
    t.string  "codigo_ibge",     limit: 7
    t.integer "estado_id"
  end

  add_index "localidades", ["codigo_correios"], name: "index_localidades_on_codigo_correios", using: :btree

  create_table "locatarios", force: :cascade do |t|
    t.integer  "seguro_fianca_id"
    t.string   "nome"
    t.string   "cpf_cnpj"
    t.string   "estado_civil"
    t.string   "residira_no_imovel"
    t.float    "renda"
    t.integer  "vinculo_empregaticio"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "logradouros", force: :cascade do |t|
    t.string  "uf",            limit: 2
    t.integer "codigo_cidade"
    t.integer "codigo_bairro"
    t.string  "nome"
    t.string  "complemento"
    t.string  "cep",           limit: 8
    t.string  "tipo"
    t.string  "nome_bairro",   limit: 255
    t.integer "estado_id"
  end

  add_index "logradouros", ["cep"], name: "index_logradouros_on_cep", using: :btree
  add_index "logradouros", ["codigo_bairro"], name: "index_logradouros_on_codigo_bairro", using: :btree
  add_index "logradouros", ["codigo_cidade"], name: "index_logradouros_on_codigo_cidade", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "imobiliaria_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mensagens", force: :cascade do |t|
    t.string   "titulo"
    t.text     "texto"
    t.boolean  "ativo"
    t.date     "inicio"
    t.date     "fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mensagens_users", force: :cascade do |t|
    t.integer "mensagem_id"
    t.integer "user_id"
  end

  create_table "seguros", force: :cascade do |t|
    t.string   "cep",                       limit: 255
    t.string   "numero",                    limit: 255
    t.string   "complemento",               limit: 255
    t.string   "residencia",                limit: 255
    t.string   "inquilino",                 limit: 255
    t.string   "tipo_pessoa",               limit: 255
    t.string   "cpf_cnpj_inquilino",        limit: 255
    t.string   "proprietario",              limit: 255
    t.string   "cpf_cnpj_proprietario",     limit: 255
    t.float    "limite_maximo_indenizacao"
    t.float    "cobertura_para_conteudo"
    t.float    "premio_total"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipo_de_seguro",                        null: false
    t.string   "tipo_pessoa_proprietario"
    t.integer  "imobiliaria_id"
    t.integer  "atividade_id"
    t.boolean  "marcado"
    t.integer  "arquivo_id"
    t.datetime "transmitido_em"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.boolean  "renovado"
    t.date     "data_limite_renovacao"
    t.integer  "transmitido_por_id"
  end

  add_index "seguros", ["imobiliaria_id"], name: "index_seguros_on_imobiliaria_id", using: :btree

  create_table "seguros_fiancas", force: :cascade do |t|
    t.integer  "finalidade"
    t.string   "cep"
    t.string   "numero"
    t.string   "complemento"
    t.string   "tipo_do_imovel"
    t.float    "valor_aluguel"
    t.float    "valor_condominio"
    t.float    "valor_iptu"
    t.boolean  "danos_ao_imovel"
    t.boolean  "multa_recisoria"
    t.boolean  "pintura_interna"
    t.boolean  "pintura_externa"
    t.integer  "user_id"
    t.integer  "imobiliaria_id"
    t.integer  "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "titulos", force: :cascade do |t|
    t.string   "finalidade_do_imovel"
    t.string   "tipo_do_imovel"
    t.string   "cep"
    t.string   "numero"
    t.string   "complemento"
    t.float    "valor_locacao"
    t.string   "locatario_nome"
    t.string   "locatario_tipo"
    t.string   "locatario_cpf_cnpj"
    t.date     "locatario_data_nascimento"
    t.string   "locatario_rg"
    t.string   "locatario_orgao_emissor"
    t.date     "locatario_data_expedicao"
    t.string   "locatario_profissao"
    t.string   "locatario_telefone"
    t.string   "locatario_email"
    t.string   "locador_nome"
    t.string   "locador_tipo"
    t.string   "locador_cpf_cnpj"
    t.float    "valor_titulo"
    t.integer  "meses_do_titulo"
    t.integer  "user_id"
    t.integer  "imobiliaria_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "responsavel_legal_nome"
    t.string   "responsavel_legal_rg"
    t.string   "responsavel_legal_cpf"
    t.string   "locatario_atividade"
    t.string   "multiplicador_do_titulo"
    t.integer  "pago",                      default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                     limit: 40
    t.string   "name",                      limit: 100, default: ""
    t.string   "email",                     limit: 100
    t.string   "encrypted_password",        limit: 128, default: "",    null: false
    t.string   "password_salt",                         default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            limit: 40
    t.datetime "remember_token_expires_at"
    t.string   "tipo",                      limit: 255
    t.datetime "confirmed_at"
    t.boolean  "active"
    t.integer  "imobiliaria_id"
    t.boolean  "admin_corretora"
    t.boolean  "bloqueio_proposta"
    t.boolean  "primeiro_acesso"
    t.boolean  "master"
    t.boolean  "add_atividade"
    t.boolean  "edit_atividade"
    t.boolean  "edit_imobiliaria"
    t.boolean  "new_imobiliaria"
    t.boolean  "bloqueia_imobiliaria"
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.string   "role"
    t.integer  "sign_in_count",                         default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "reset_password_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                       default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "somente_calculo"
    t.string   "avatar",                                default: "one"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
