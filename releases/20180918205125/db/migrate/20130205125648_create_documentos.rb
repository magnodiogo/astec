class CreateDocumentos < ActiveRecord::Migration
  def self.up
    create_table :documentos do |t|
      t.references :imobiliaria
      t.string :documento_file_name
      t.string :documento_content_type
      t.string :documento_file_size
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :documentos
  end
end
