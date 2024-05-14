module SegurosFiancasHelper
  def options_finalidade_seguro_fianca
    [["Residencial – PF", 1], ["Residencial – PJ", 2], ["Empresarial – PF (Empreendedor)", 3], ["Empresarial – PJ", 4]]
  end
  def finalidade_desc(val)
    options_finalidade_seguro_fianca.each do |k, v|
      if v == val
        return k
      end
    end
  end

  def options_vinculo_empregaticio_locatario
    [
      ["Aposentado / Pensionista", 1], 
      ["Autônomo", 2], 
      ["Empresário", 3], 
      ["Estudante", 4], 
      ["Funcionário Público", 5], 
      ["Funcionário com registo CLT", 6], 
      ["Profissional Liberal", 7], 
      ["Renda Proveniente de Aluguéis", 8]
    ]
  end
  def vinculo_empregaticio_locatario_desc(val)
    options_vinculo_empregaticio_locatario.each do |k, v|
      if v == val
        return k
      end
    end
  end

  def descricao_pago_seguro_fianca(object = nil)
    ret = case object.status.to_i
      when 0 then
        "<span class='falert'>Em Análise</span>"
      when 1 then 
        "<span class='fsuccess'>Enviado</span>"
      when 2 then 
        "<span class='fdanger'>Recusado</span>"
    end
    ret.html_safe
  end
end
