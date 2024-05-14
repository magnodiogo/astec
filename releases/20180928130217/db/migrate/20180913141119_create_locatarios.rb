class CreateLocatarios < ActiveRecord::Migration
  def change
    create_table :locatarios do |t|
      t.integer :seguro_fianca_id
      t.string :nome
      t.string :cpf_cnpj
      t.string :estado_civil
      t.string :residira_no_imovel
      t.float :renda
      t.integer :vinculo_empregaticio

      t.timestamps null: false
    end
  end
end
