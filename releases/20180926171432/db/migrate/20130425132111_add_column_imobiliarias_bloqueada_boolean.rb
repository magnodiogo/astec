class AddColumnImobiliariasBloqueadaBoolean < ActiveRecord::Migration
  def self.up
    add_column :imobiliarias, :bloqueada, :boolean
  end

  def self.down
     remove_column :imobiliarias, :bloqueada
  end

end
