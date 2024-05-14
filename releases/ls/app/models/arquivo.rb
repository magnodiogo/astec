class Arquivo < ActiveRecord::Base

  has_many :seguros
  attr_accessor :imobiliaria_id, :tipo

  def nome
    if self.url 
      return self.url.slice(self.url.index('/', 10)+1, self.url.size)
    else
      return ''
    end
  end
end
