class InsertEstados < ActiveRecord::Migration
  def change
    ["AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO"].each do |uf|
      Estado.create(uf: uf)
    end
  end
end
