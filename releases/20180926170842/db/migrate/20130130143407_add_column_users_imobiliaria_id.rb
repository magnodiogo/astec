class AddColumnUsersImobiliariaId < ActiveRecord::Migration
  def self.up
    add_column :users, :imobiliaria_id, :integer
  end

  def self.down
    remove_column :users, :imobiliaria_id
  end
end
