class AddPagoTotitulos < ActiveRecord::Migration
  def change
    add_column :titulos, :pago, :boolean, { default: :false }
  end
end
