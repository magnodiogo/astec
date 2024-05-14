class AddColumnUsersBloqueioProposta < ActiveRecord::Migration
  def self.up
     add_column :users, :bloqueio_proposta, :boolean
  end


  def self.down
     remove_column :users, :bloqueio_proposta
  end
end
