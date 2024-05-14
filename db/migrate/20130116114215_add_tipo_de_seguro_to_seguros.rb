class AddTipoDeSeguroToSeguros < ActiveRecord::Migration
  def self.up
    add_column :seguros, :tipo_de_seguro, :varchar, :size => 1, :null => false
  end

  def self.down
    remove_column :seguros, :tipo_de_seguro
  end
end
