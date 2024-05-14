class AddColumnIdAntigoImob < ActiveRecord::Migration
  def self.up
     add_column :imobiliarias, :id_antigo, :integer
  end

  def self.down
  end
end
