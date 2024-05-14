class InsertEstadoIdToLogradouros < ActiveRecord::Migration
  def change
    Estado.all.each do |e|
      Logradouro.where(uf: e.uf).update_all(estado_id: e.id)
      Localidade.where(uf: e.uf).update_all(estado_id: e.id)
    end
  end
end
