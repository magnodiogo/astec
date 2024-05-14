class CreateTitulos < ActiveRecord::Migration
  def self.up
    create_table :titulos do |t|
      t.string  :finalidade_do_imovel
      t.string  :tipo_do_imovel
      t.string  :cep
      t.string  :numero
      t.string  :complemento
      t.float   :valor_locacao
      t.string  :locatario_nome
      t.string  :locatario_tipo
      t.string  :locatario_cpf_cnpj
      t.date    :locatario_data_nascimento
      t.string  :locatario_rg
      t.string  :locatario_orgao_emissor
      t.date    :locatario_data_expedicao
      t.string  :locatario_profissao
      t.string  :locatario_telefone
      t.string  :locatario_email
      t.string  :locador_nome
      t.string  :locador_tipo
      t.string  :locador_cpf_cnpj
      t.float   :valor_titulo
      t.integer :meses_do_titulo
      t.integer :user_id
      t.integer :imobiliaria_id

      t.timestamps
    end
  end

  def self.down
    drop_table :titulos
  end
end
