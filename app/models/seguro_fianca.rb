class SeguroFianca < ActiveRecord::Base
  require "#{Rails.root}/lib/valida_cpf_cnpj.rb"
  include ValidaCpfCnpj

  # Relacionamentos
  belongs_to :user
  belongs_to :imobiliaria
  belongs_to :logradouro, foreign_key: :cep, primary_key: :cep
  has_many   :locatarios
  accepts_nested_attributes_for :locatarios

  # Validações
  validates_inclusion_of :danos_ao_imovel, in: [true, false]
  validates_inclusion_of :multa_recisoria, in: [true, false]
  validates_inclusion_of :pintura_interna, in: [true, false]
  validates_inclusion_of :pintura_externa, in: [true, false]
  validates_presence_of  :finalidade, :cep, :numero,  :valor_aluguel
  validate :validar_numero
  validate :validar_complemento

  def finalidade_desc
    case self.finalidade
      when 1 then 'Residencial – PF'
      when 2 then 'Residencial – PJ'
      when 3 then 'Empresarial – PF (Empreendedor)'
      when 4 then 'Empresarial – PJ'
    end
  end

  private
    def validar_numero
      if self.numero.size != self.numero.to_s.gsub(/[^0-9]/, '').size
        self.errors.add(:numero, "aceita apenas números (0-9)")
        return false
      end
    end

    def validar_complemento
      if self.complemento.size != self.complemento.to_s.gsub(/[^0-9|A-Z|a-z|\s]/, '').size
        self.errors.add(:complemento, "aceita apenas números e letras (0-9, a-z, A-Z)")
        return false
      end
    end

end