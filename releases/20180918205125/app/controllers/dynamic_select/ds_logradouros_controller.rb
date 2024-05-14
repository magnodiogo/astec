module DynamicSelect
  class DsLogradourosController < ApplicationController
    respond_to :json

    def index
      @localidades = Localidade.where(estado_id: params[:estado_id]).order(:nome).select(:nome, :codigo_correios)
      render json: @localidades.collect{ |l| { id: l.codigo_correios, nome: l.nome} }
      #respond_with(@localidades)
    end
  end
end
