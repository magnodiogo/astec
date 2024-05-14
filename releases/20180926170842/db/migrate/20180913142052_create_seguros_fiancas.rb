class CreateSegurosFiancas < ActiveRecord::Migration
  def change
    create_table :seguros_fiancas do |t|
      t.integer :finalidade
      t.string :cep
      t.string :numero
      t.string :complemento
      t.string :tipo_do_imovel
      t.float :valor_aluguel
      t.float :valor_condominio
      t.float :valor_iptu
      t.boolean :danos_ao_imovel
      t.boolean :multa_recisoria
      t.boolean :pintura_interna
      t.boolean :pintura_externa
      t.integer :user_id
      t.integer :imobiliaria_id
      t.integer :status
      t.timestamps null: false
    end
  end
end
