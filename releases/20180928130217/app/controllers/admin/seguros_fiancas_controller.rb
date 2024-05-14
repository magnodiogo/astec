class Admin::SegurosFiancasController < AdminController
  before_filter :set_seguro_fianca, only: [:show, :destroy, :alterar_pagamento]

  def index
    cond = {}
    if params[:imobiliaria_id].present?
      cond = { imobiliaria_id: params[:imobiliaria_id] }
    end
    @seguros_fiancas = SeguroFianca.where(cond).
                      includes(:imobiliaria, :logradouro, :locatarios).
                      order(id: :desc).paginate(page: params[:page])
  end

  def show
  end

  def alterar_pagamento
    if params[:pendente].present? and @seguro_fianca.update(status: 0)
      redirect_to :back, notice: "Seguro Fiança retornado ao status de pendente"
    elsif @seguro_fianca.update(status: (params[:pagamento].present? ? 1 : 2))
      redirect_to :back, notice: "Seguro Fiança atualizado com sucesso"
    else
      redirect_to :back, flash: { error: @seguro_fianca.errors.full_messages }
    end
  end

  def relatorios
    if request.post?
      if params[:data_inicial].present? and params[:data_final].present? 
        if params[:imobiliaria_id].present?
          @imobiliaria = Imobiliaria.find(params[:imobiliaria_id]) 
          cond         = {imobiliaria_id: params[:imobiliaria_id].to_i }  
        end
        @seguros     = SeguroFianca.where("created_at::date between ? and ? ", params[:data_inicial], params[:data_final]).
                              where(cond).includes(:imobiliaria, :logradouro, :user).
                              order(:created_at)
      else
        redirect_to :back, flash: { error: "Preencha todos os campos e tente novamente."}
        return
      end
      render layout: false
    end
  end

  def destroy
    if @seguro_fianca.destroy
      redirect_to :back, notice: "Seguro Fiança excluído com sucesso"
    end
  end

  private
    def set_seguro_fianca
      @seguro_fianca = SeguroFianca.find(params[:id])
    end
end
