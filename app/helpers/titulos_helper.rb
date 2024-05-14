module TitulosHelper
  def options_finalidade_do_imovel
    [["Residencial", "R"], ["Empresarial", "E"], ["Veraneio", "V"], ["Outros", "O"]]
  end

  def options_tipo_do_imovel
    [["Apartamento", "A"], ["Box", "B"], ["Casa", "C"], ["Flat", "F"], ["Galpão", "G"], ["Loja", "L"], ["Outros", "O"], ["Quiosque", "Q"], ["Sala Comercial", "S"]]
  end

  def finalidade_do_imovel_desc(val)
    options_finalidade_do_imovel.each do |k, v|
      if v == val
        return k
      end
    end
  end

  def tipo_do_imovel_desc(val)
    options_tipo_do_imovel.each do |k, v|
      if v == val
        return k
      end
    end
  end

  def descricao_multiplicador_do_titulo(object)
    case object.multiplicador_do_titulo
      when 'M' then 'Multiplos por Aluguel'
      when 'A' then 'Aluguel mais Encargos'
    end
  end

  def options_locatario_tipo
    [["Pessoa Física", "PF"],["Pessoa Jurídica", "PJ"]]
  end

  def options_meses_do_titulo
    [["12 Meses", 12 ], ["15 Meses", 15]]
  end

  def endereco_formatado(object)
    retorno = ""
    cep = Logradouro.find_by_cep(object.cep)
    if cep
      retorno = cep.endereco + ', ' + object.numero
      retorno << ' ' + object.complemento unless object.complemento.blank?
    end
    return retorno
  end

  def descricao_finalidade_do_imovel(object = '')
    case object.finalidade_do_imovel
      when "R" then "Residencial"
      when "E" then "Empresarial"
      when "V" then "Veraneio"
      when "O" then "Outros"
      else 
        "Não definido."
    end
  end

  def descricao_pago_titulo(object = nil)
    ret = case object.pago.to_i
      when 0 then 
        "<span class='falert'>Pendente</span>"
      when 1 then 
        "<span class='fsuccess'>Pago</span>"
      when 2 then 
        "<span class='fdanger'>Recusado</span>"
    end
    ret.html_safe
  end

  def descricao_tipo_do_imovel(object = '')
    case object 
      when "A"  then "Apartamento"
      when "B"  then "Box"
      when "C"  then "Casa"
      when "D"  then "Depósito"
      when "E"  then "Empresarial"
      when "F"  then "Flat"
      when "G"  then "Galpão"
      when "I"  then "Industrial"
      when "L"  then "Loja"
      when "O"  then "Outros"
      when "Q"  then "Quiosque"
      when "R"  then "Residencial"
      when "S"  then "Sala Comercial"
      when "SC" then "Loja em Shopping Center"
      else 
        "Não definido."
    end
  end

  def descricao_locatario_tipo(object)
    case object.finalidade_do_imovel 
      when "PF" then "Pessoa Física"
      when "PJ" then "Pessoa Jurídica"
      else 
        "Não definido."
    end
  end

  def descricao_meses_do_titulo(object)
    case object.finalidade_do_imovel 
      when 12 then "12 Meses"
      when 15 then "15 Meses"
      else 
        "Não definido."
    end
  end

end
