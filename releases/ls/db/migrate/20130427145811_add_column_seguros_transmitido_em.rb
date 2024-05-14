class AddColumnSegurosTransmitidoEm < ActiveRecord::Migration
  def self.up
    add_column :seguros, :transmitido_em, :timestamp
  end

  def self.down
    remove_column :seguros, :transmitido_em
  end
end
