class Locatario < ActiveRecord::Base
  require "#{Rails.root}/lib/valida_cpf_cnpj.rb"
  include ValidaCpfCnpj

  # Relacionamentos
  belongs_to :seguro_fianca

  # Validações
  validate :validar_cpf_cnpj

  def vinculo_empregaticio_desc 
    case self.vinculo_empregaticio
      when 1 then 'Aposentado / Pensionista'
      when 2 then 'Autônomo'
      when 3 then 'Empresário'
      when 4 then 'Estudante'
      when 5 then 'Funcionário Público'
      when 6 then 'Funcionário com registo CLT'
      when 7 then 'Profissional Liberal'
      when 8 then 'Renda Proveniente de Aluguéis'
    end
  end

  private
    def validar_cpf_cnpj
      self.cpf_cnpj.to_s.gsub!(/[^0-9]/, '')
      if self.cpf_cnpj.present?
        if self.cpf_cnpj.size > 11
          if not valida_cnpj(self.cpf_cnpj) 
             errors.add(:cpf_cnpj, ' é inválido')
          end
        elsif not valida_cpf(self.cpf_cnpj) 
          errors.add(:cpf_cnpj, ' é inválido')
        end
      end
    end


end
