class AddEnderecoToCorretoras < ActiveRecord::Migration
  def self.up
    add_column :corretoras, :endereco, :string, :limit => 40
    add_column :corretoras, :numero, :string, :limit => 6 
    add_column :corretoras, :complemento, :string, :limit => 15
    add_column :corretoras, :bairro, :string, :limit => 20
    add_column :corretoras, :cidade, :string, :limit => 40
    add_column :corretoras, :uf, :string, :limit => 2
    add_column :corretoras, :cep, :string, :limit => 8
  end

  def self.down
    remove_column :corretoras, :cep
    remove_column :corretoras, :uf
    remove_column :corretoras, :cidade
    remove_column :corretoras, :bairro
    remove_column :corretoras, :complemento
    remove_column :corretoras, :numero
    remove_column :corretoras, :endereco
  end
end
