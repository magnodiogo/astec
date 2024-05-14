class CreateFiancas < ActiveRecord::Migration
  def self.up
    create_table :fiancas do |t|
      t.string :locatario_nome
      t.string :locatario_sexo
      t.string :locatario_cpf
      t.string :locatario_rg
      t.string :locatario_orgao_expedidor
      t.date :locatario_data_expedicao
      t.string :locatario_nacionalidade
      t.date :locatario_nascimento
      t.string :locatario_estado_civil
      t.string :locatario_mae
      t.string :locatario_pai
      t.boolean :locatario_residira_no_imovel
      t.boolean :locatario_compora_renda
      t.boolean :locatario_correntista
      t.string :locatario_segmoneto
      t.string :locatario_email_primario
      t.string :locatario_email_secundario
      t.string :imovel_tipo
      t.string :imovel_cep
      t.string :imovel_numero
      t.string :imovel_complemento
      t.string :imovel_administradora
      t.float :imovel_aluguel
      t.float :imovel_iptu
      t.float :imovel_condominio
      t.float :imovel_agua
      t.float :imovel_luz
      t.float :imovel_gas_canalizado
      t.float :imovel_danos
      t.float :imovel_multa_recisao
      t.float :imovel_pintura_interna
      t.float :imovel_puntura_externa
      t.string :residencia_tipo
      t.integer :residencia_tempo_ano
      t.integer :residencia_tempo_mes
      t.string :residencia_cep
      t.string :residencia_numero
      t.string :residencia_complemento
      t.string :residencia_ddd_fixo
      t.string :residencia_telefone_fixo
      t.string :residencia_ddd_celular
      t.string :residencia_celular
      t.string :residencia_nome_proprietario
      t.string :residencia_ddd_proprietario
      t.string :residencia_telefone_proprietario
      t.boolean :residencia_correspondencia
      t.string :correspondencia_cep
      t.string :correspondencia_numero
      t.string :correspondencia_complemento
      t.string :anterior_tipo
      t.integer :anterior_tempo_ano
      t.integer :anterior_tempo_mes
      t.string :anterior_cep
      t.string :anterior_numero
      t.string :anterior_complemento
      t.string :anterior_nome_proprietario
      t.string :anterior_ddd_proprietario
      t.string :anterior_telefone_proprietario
      t.string :dependentes_tipo_1
      t.string :dependentes_nome_1
      t.string :dependentes_nascimento_1
      t.string :dependentes_tipo_2
      t.string :dependentes_nome_2
      t.string :dependentes_nascimento_2
      t.string :referencia_bancaria_codigo_banco
      t.string :referencia_bancaria_banco
      t.string :referencia_bancaria_agencia
      t.string :referencia_bancaria_conta
      t.string :referencia_bancaria_segmento
      t.date :referencia_bancaria_cliente_desde
      t.string :cartao_credito_bandeira
      t.string :cartao_credito_numero
      t.date :cartao_credito_validade
      t.string :referencia_comercial_empresa
      t.string :referencia_comercial_ddd
      t.string :referencia_comercial_telefone
      t.string :referencia_comercial_ramal
      t.string :referencia_pessoal_nome
      t.string :referencia_pessoal_ddd
      t.string :referencia_pessoal_telefone
      t.string :bens_moveis_tipo
      t.string :bens_moveis_fabricante
      t.string :bens_moveis_modelo
      t.string :bens_moveis_placa
      t.float :bens_moveis_valor
      t.boolean :bens_moveis_onus
      t.string :bens_moveis_instituicao
      t.integer :bens_moveis_ano
      t.boolean :bens_moveis_seguro
      t.string :bens_moveis_seguradora
      t.string :bens_imoveis_tipo
      t.string :bens_imoveis_cep
      t.string :bens_imoveis_numero
      t.string :bens_imoveis_complemento
      t.float :bens_imoveis_valor
      t.boolean :bens_imoveis_onus
      t.boolean :bens_imoveis_segura
      t.string :bens_imoveis_seguradora
      t.string :locatario_ocupacao
      t.string :locatario_categoria
      t.string :locatario_empresa_nome
      t.string :locatario_empresa_ddd
      t.string :locatario_empresa_telefone
      t.string :locatario_empresa_ramal
      t.string :locatario_empresa_cep
      t.string :locatario_empresa_numero
      t.string :locatario_empresa_complemento
      t.date :locatario_empresa_data_admissao
      t.string :locatario_empresa_cargo
      t.float :locatario_empresa_salario
      t.string :locatario_empresa_outras_rendas
      t.float :locatario_empresa_valor
      t.string :locatario_anterior_nome
      t.string :locatario_anterior_ddd
      t.string :locatario_anterior_telefone
      t.string :locatario_anterior_ramal
      t.string :locatario_anterior_cep
      t.string :locatario_anterior_numero
      t.string :locatario_anterior_complemento
      t.string :locatario_anterior_cargo
      t.float :locatario_anterior_salario
      t.string :locador_nome
      t.string :locador_cpf
      t.string :locador_email
      t.float :locador_renda
      t.string :locador_rg
      t.string :locador_orgao_expedidor
      t.date :locador_data_expedicao
      t.string :locador_ddd_fixo
      t.string :locador_telefone_fixo
      t.string :locador_ddd_celular
      t.string :locador_celular
      t.string :locador_cep
      t.string :locador_numero
      t.string :locador_complemento
      t.integer :imobiliaria_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fiancas
  end
end
