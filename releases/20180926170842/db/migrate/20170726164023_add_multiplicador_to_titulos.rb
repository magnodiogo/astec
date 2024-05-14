class AddMultiplicadorToTitulos < ActiveRecord::Migration
  def change
    add_column :titulos, :multiplicador_do_titulo, :string
  end
end
