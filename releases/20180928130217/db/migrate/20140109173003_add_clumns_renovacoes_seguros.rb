class AddClumnsRenovacoesSeguros < ActiveRecord::Migration
  def self.up
add_column :seguros, :parent_id, :integer
add_column :seguros, :renovado, :boolean
  end

  def self.down
  end
end
