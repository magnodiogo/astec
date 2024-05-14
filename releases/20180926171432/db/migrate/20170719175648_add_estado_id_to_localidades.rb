class AddEstadoIdToLocalidades < ActiveRecord::Migration
  def change
    add_column :localidades, :estado_id, :integer
    add_column :logradouros, :estado_id, :integer
  end
end
