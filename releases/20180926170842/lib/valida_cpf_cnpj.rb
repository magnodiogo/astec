module ValidaCpfCnpj
  def valida_cpf(value)
    value = value.to_s
    value.gsub!(/[^0-9]/,'')
    controle = ""
    digito = value.slice(-2,2)
    if value.size == 11 then
      fator = 0
      2.times do |i|
        soma = 0
        9.times do |j|
          soma += value.slice(j,1).to_i * (10 + i - j)
        end
        soma += (fator * 2) if i == 1
        fator = (soma * 10) % 11
        fator = 0 if (fator == 10)
        controle << fator.to_s
      end
    end
    (controle == digito)
  end

  def valida_cnpj(value)
    value = value.to_s
    value.gsub!(/[^0-9]/,'')
    controle = ""
    digito = value.slice(-2,2)
    value = value.slice(1,value.size) if (value.size == 15)
    if value.size == 14 then
       fator = 0
       2.times do |i|
          soma = 0
          12.times do |j|
            soma += value.slice(j,1).to_i * ((11 + i - j) % 8 + 2)
          end
          soma += (fator * 2) if i == 1
          fator = 11 - soma % 11
          fator = 0 if (fator > 9)
          controle << fator.to_s
       end
    end
    (controle == digito)
  end
end
