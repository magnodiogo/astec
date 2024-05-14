class AddCamposToSeguros < ActiveRecord::Migration
  def self.up
    add_column :seguros, :tipo_pessoa_proprietario, :varchar, :nil => false, :size => 2
    add_column :seguros, :imobiliaria_id, :integer, :nil => false
    add_index  :seguros, :imobiliaria_id
  end

  def self.down
    remove_column :seguros, :tipo_pessoa_proprietario
    add_column :seguros, :imobiliaria_id
  end
end

