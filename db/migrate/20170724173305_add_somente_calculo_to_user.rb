class AddSomenteCalculoToUser < ActiveRecord::Migration
  def change
    add_column :users, :somente_calculo, :boolean
  end
end
