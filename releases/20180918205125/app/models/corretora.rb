class Corretora < ActiveRecord::Base

  before_save :retira_mascara

  def retira_mascara
    self.cep = self.cep.gsub('-','')
  end

  def tipo_de_pessoa_desc
    r = case self.tipo_de_pessoa
      when 'J' then 'Jurídica'
      else
        'Física'
    end
    return r
  end
end