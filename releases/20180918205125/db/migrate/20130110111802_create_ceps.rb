class CreateCeps < ActiveRecord::Migration
  def self.up
    create_table :ceps do |t|
      t.string :cep, :nil => false, :size => 8
      t.string :endereco, :nil => false, :size => 40
      t.string :bairro, :nil => false, :size => 30
      t.string :cidade, :nil => false, :size => 30
      t.string :uf, :nil => false, :size => 2
      t.timestamps
    end

    add_index :ceps, :cep, :unique => true
  end

  def self.down
    drop_table :ceps
  end
end
