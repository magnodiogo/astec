class CreateAtividades < ActiveRecord::Migration
  def self.up
    create_table :atividades do |t|
      t.string :codigo
      t.string :atividade
      t.text :observacao
      t.boolean :bloqueado

      t.timestamps
    end
  end

  def self.down
    drop_table :atividades
  end
end
