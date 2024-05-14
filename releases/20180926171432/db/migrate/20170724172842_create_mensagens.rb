class CreateMensagens < ActiveRecord::Migration
  def change
    create_table :mensagens do |t|
      t.string :titulo
      t.text :texto
      t.boolean :ativo
      t.date :inicio
      t.date :fim

      t.timestamps null: false
    end
    create_table :mensagens_users do |t|
      t.references :mensagem, :user
    end
    create_table :imobiliarias_mensagens do |t|
      t.references :mensagem, :imobiliaria
    end
  end
end
