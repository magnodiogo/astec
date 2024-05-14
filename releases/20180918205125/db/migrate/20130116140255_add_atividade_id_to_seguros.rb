class AddAtividadeIdToSeguros < ActiveRecord::Migration
  def self.up
    add_column :seguros, :atividade_id, :integer
  end

  def self.down
    remove_column :seguros, :atividade_id
  end
end
