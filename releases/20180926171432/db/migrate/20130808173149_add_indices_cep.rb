class AddIndicesCep < ActiveRecord::Migration
  def self.up
     add_index :logradouros, :cep
     add_index :logradouros, :codigo_cidade
     add_index :logradouros, :codigo_bairro
     add_index :bairros, :codigo_correios
     add_index :localidades, :codigo_correios
  end

  def self.down
  end
end
