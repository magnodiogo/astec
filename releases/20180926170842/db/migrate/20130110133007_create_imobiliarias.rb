class CreateImobiliarias < ActiveRecord::Migration
  def self.up
    create_table :imobiliarias do |t|
      t.string :nome_fantasia, :size => 60
      t.string :estipulante, :size => 60
      t.string :tipo_pessoa, :size => 1
      t.string :cpf_cnpj, :size => 14
      t.date :data_nascimento
      t.string :ie_rg, :size => 15
      t.date :data_expedicao
      t.string :orgao_expeditor, :size => 20
      t.string :endereco, :size => 40
      t.string :numero, :size => 6
      t.string :complemento, :size => 15
      t.string :bairro, :size => 20
      t.string :cidade, :size => 40
      t.string :estado, :size => 2
      t.string :telefone, :size => 10
      t.string :celular, :size => 10
      t.string :contato, :size => 20
      t.string :email, :size => 60
      t.string :retorno, :size => 2
      t.string :operacao, :size => 4
      t.float :taxa_residencial
      t.float :taxa_empresarial
      t.boolean :valor_no_recibo
      t.string :pro_laborista, :size => 5

      t.timestamps
    end
  end

  def self.down
    drop_table :imobiliarias
  end
end
