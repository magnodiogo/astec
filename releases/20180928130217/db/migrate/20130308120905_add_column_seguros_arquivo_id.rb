class AddColumnSegurosArquivoId < ActiveRecord::Migration
  def self.up
     add_column :seguros, :arquivo_id, :integer
  end

  def self.down
     remove_column :seguros, :arquivo_id
  end
end
