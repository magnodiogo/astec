class LogradourosController < ApplicationController

  def titulo_search_cep
    if request.post?
      if params[:cidade].blank?
        @ufs     = Localidade.select("distinct(uf)").order(:uf).collect{|l| l.uf }.insert(0, "") 
        @cidades = Localidade.select("distinct(nome), id").where(uf: 'AC').order(:nome).collect{|l| [l.nome,l.id] }.insert(0, '')
        flash[:error] = "Selecione a cidade para realizar a consulta"
        return
      end 
      cond = []
      cond << ''
      if params[:endereco].present?
        cond[0] += "upper(logradouros.tipo || ' ' || logradouros.nome) like ?"
        cond    << '%' + params[:endereco].upcase + '%'
      end
      if params[:nome_bairro].present?
        cond[0] += " and "    if cond.size > 1
        cond[0] += "upper(logradouros.nome_bairro) like ?"
        cond    << '%' + params[:nome_bairro].upcase + '%'
      end
      if params[:nome].present?
        cond[0] += " and "    if cond.size > 1
        cond[0] += "upper(logradouros.nome) like ?"
        cond    << '%' + params[:nome].upcase + '%'
      end
      cond[0]  += " and "    if cond.size > 1
      cond[0]  += "l.id = ?"
      cond     << params[:cidade]
      @ceps = Logradouro.joins("join localidades l on l.codigo_correios = logradouros.codigo_cidade").where(cond).
                         order("cep asc, logradouros.nome, logradouros.complemento, logradouros.nome_bairro").limit(100)
    end
    @ufs     = Localidade.select("distinct(uf)").order(:uf).collect{|l| l.uf }.insert(0, "")
    @cidades = []
  end

  def search_cep
    if params[:format] == 'json'
      logradouro = Logradouro.where(cep: params[:cep].gsub(/[^0-9]/, '')).first
      if logradouro
        json = { endereco: logradouro.endereco, 
                 bairro:   logradouro.nome_bairro,  
                 cidade:   logradouro.localidade.nome, 
                 uf:       logradouro.uf 
               }
      else
        json = {}
      end
      render json: json
    else
      @tipo = params[:tipo]
      @mes  = params[:mes]
       
      @logradouro = Logradouro.new
      cond = []
      if params[:logradouro].present?
        cond << ""
        @logradouro = Logradouro.new(logradouro_params)
        if @logradouro.nome_bairro.present?
          cond = ["upper(nome_bairro) like ?", "%" + @logradouro.nome_bairro.upcase  + "%"]
        end
        if @logradouro.estado_id.present?
          cond[0] += " and " unless cond[0].blank?
          cond[0] += " estado_id = ? "
          cond    << @logradouro.estado_id
        end
        if  @logradouro.nome.present?
          cond[0] += " and "    if cond.size > 1
          cond[0] += "upper(logradouros.nome) like ?"
          cond    << '%' + @logradouro.nome.upcase + '%'
        end
        if @logradouro.codigo_cidade.present?
          cond[0] += " and " unless cond[0].blank?
          cond[0] += " codigo_cidade = ? "
          cond << @logradouro.codigo_cidade
        end
        if @logradouro.cep.present?
          cond[0] += " and " unless cond[0].blank?
          cond[0] += " cep like ? "
          cond    << "%" + @logradouro.cep + "%"
        end
      end

      if cond[0].present?
        @logradouros = Logradouro.where(cond).includes(:localidade).order(:cep, :nome, :complemento, :nome_bairro).paginate(page: params[:page])
        @cidades     = Localidade.where(estado_id: @logradouro.estado_id || 6).order(:nome)
      end
      @estados     = Estado.order(:id)
    end
  end

  private
    def logradouro_params
      params.require(:logradouro).permit( :uf, :codigo_cidade, :codigo_bairro, :nome, :complemento, 
                                          :cep, :tipo, :nome_bairro, :complemento, :estado_id)
    end
end