class CreateCorretoras < ActiveRecord::Migration
  def self.up
    create_table :corretoras do |t|
      t.string :codigo_sucursal, :size => 2
      t.string :codigo_corretor, :size => 5
      t.string :codigo_colaborador, :size => 5
      t.string :codigo_susep, :size => 14
      t.string :tipo_de_pessoa, :size => 1
      t.string :razao_social, :size => 40
      t.string :codigo_da_inspetoria, :size => 6
      t.string :codigo_do_inspetor, :size => 6
      t.string :email_corretor, :size => 60
      t.string :ddd_corretor, :size => 2
      t.string :telefone_corretor, :size => 9
      t.float :iof
      t.timestamps
    end
  end

  def self.down
    drop_table :corretoras
  end
end
