class AddColumnSegurosMarcado < ActiveRecord::Migration
  def self.up
     add_column :seguros, :marcado, :boolean
  end

  def self.down
     remove_column :seguros, :marcado
  end
end
