class Atividade < ActiveRecord::Base
  validates_uniqueness_of :codigo
  validates_presence_of   :codigo, :atividade
end
