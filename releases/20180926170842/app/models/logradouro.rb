class Logradouro < ActiveRecord::Base

  # Relacionamentos
  belongs_to :localidade, class_name: "Localidade", foreign_key: :codigo_cidade, primary_key: :codigo_correios
  belongs_to :bairro,     class_name: "Localidade", foreign_key: :codigo_bairro, primary_key: :codigo_correios


  # Validações
  validates_uniqueness_of :cep
  validates_presence_of   :cep, :nome, :estado_id, :tipo, :nome_bairro, :codigo_cidade, :messages => ' é obrigatório.'

  before_save :set_estado

  def endereco
    self.tipo + " " + self.nome
  end

  def cep_formatado
    if self.cep
      return self.cep.slice(0,5).to_s + '-' + self.cep.slice(5,3).to_s
    else
      ''
    end
  end

  def set_estado
    if self.uf
      self.estado_id = Estado.where(uf: self.uf).first.id
    elsif self.estado_id
      self.uf = Estado.find(self.estado_id).uf
    end
  end
end