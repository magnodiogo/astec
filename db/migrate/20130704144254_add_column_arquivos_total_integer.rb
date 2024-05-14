class AddColumnArquivosTotalInteger < ActiveRecord::Migration
  def self.up
     add_column :arquivos, :total, :integer
  end

  def self.down
     remove_column :arquivos, :total
  end
end
