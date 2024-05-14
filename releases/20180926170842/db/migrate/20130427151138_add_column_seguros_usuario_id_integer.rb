class AddColumnSegurosUsuarioIdInteger < ActiveRecord::Migration
  def self.up
    add_column :seguros,:user_id, :integer
  end

  def self.down
    remove_column :seguros,:user_id
  end
end
