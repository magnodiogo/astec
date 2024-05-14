module ImobiliariasHelper
  def imobiliarias
    Imobiliaria.order(:estipulante).pluck(:estipulante, :id)
  end
end
