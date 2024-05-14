class AddColumsToTitulos < ActiveRecord::Migration
  def change
    add_column :titulos, :responsavel_legal_nome, :string
    add_column :titulos, :responsavel_legal_rg, :string
    add_column :titulos, :responsavel_legal_cpf, :string
    add_column :titulos, :locatario_atividade, :string
  end
end
