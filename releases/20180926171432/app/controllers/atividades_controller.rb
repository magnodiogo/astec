class AtividadesController < ApplicationController
  #before_filter :login_required, only: [:index, :create, :update]

  skip_before_action :authenticate_user!

  def index
  	render json: Atividade.order(:atividade).pluck(:atividade)
  end

  def consultar
    render json: { observacao: Atividade.where(atividade: params[:atividade]).first.observacao }
  end
end
