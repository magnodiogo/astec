class ChangePagoToTitulos < ActiveRecord::Migration
  def change
    remove_column :titulos, :pago
    add_column :titulos, :pago, :integer, {default: 0}
  end
end
