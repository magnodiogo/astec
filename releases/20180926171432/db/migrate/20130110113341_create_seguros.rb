class CreateSeguros < ActiveRecord::Migration
  def self.up
    create_table :seguros do |t|
      t.string :cep, :nil => false, :size => 8
      t.string :numero, :nil => false, :size => 6
      t.string :complemento, :size => 15
      t.string :residencia, :nil => false, :size => 1
      t.string :inquilino, :nil => false, :size => 60
      t.string :tipo_pessoa, :nil => false, :size => 2
      t.string :cpf_cnpj_inquilino, :nil => false, :size => 14
      t.string :proprietario, :nil => false, :size => 60
      t.string :cpf_cnpj_proprietario, :nil => false, :size => 14
      t.float :limite_maximo_indenizacao
      t.float :cobertura_para_conteudo
      t.float :premio_total
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :seguros
  end
end
