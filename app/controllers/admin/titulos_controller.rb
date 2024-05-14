class Admin::TitulosController < AdminController
  before_filter :set_titulo, only: [:show, :destroy, :alterar_pagamento]

  def index
    cond = {}
    if params[:imobiliaria_id].present?
      cond = { imobiliaria_id: params[:imobiliaria_id] }
    end
    @titulos = Titulo.where(cond).
                      includes(:imobiliaria, :logradouro).
                      order(id: :desc).paginate(page: params[:page])
  end

  def show
  end

  def alterar_pagamento
    if params[:pendente].present? and @titulo.update(pago: 0)
      redirect_to :back, notice: "Título retornado ao status de pendente"
    elsif @titulo.update(pago: (params[:pagamento].present? ? 1 : 2))
      redirect_to :back, notice: "Título atualizado com sucesso"
    else
      redirect_to :back, flash: { error: @titulo.errors.full_messages }
    end
  end

  def relatorios
    if request.post?
      if params[:data_inicial].present? and params[:data_final].present? 
        if params[:imobiliaria_id].present?
          @imobiliaria = Imobiliaria.find(params[:imobiliaria_id]) 
          cond         = {imobiliaria_id: params[:imobiliaria_id].to_i }  
        end
        @seguros     = Titulo.where("created_at::date between ? and ? ", params[:data_inicial], params[:data_final]).
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
    if @titulo.destroy
      redirect_to :back, notice: "Título excluído com sucesso"
    end
  end

  private
    def set_titulo
      @titulo = Titulo.find(params[:id])
    end
end
