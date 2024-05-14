class AddCamposRenovacaoSeguros < ActiveRecord::Migration
  def self.up
     add_column :seguros, :data_limite_renovacao, :date
  end

  def self.down
  end
end
