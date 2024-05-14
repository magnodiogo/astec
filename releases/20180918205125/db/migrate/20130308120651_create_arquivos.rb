class CreateArquivos < ActiveRecord::Migration
  def self.up
    create_table :arquivos do |t|
      t.string :path
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :arquivos
  end
end
