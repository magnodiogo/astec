class EmailerController < ApplicationController
  before_filter :authenticate_user!, :except => :coberturas_pendentes

  def formulario
    if request.post?
      imobiliaria= ''
      if current_user.imobiliaria
        imobiliaria = current_user.imobiliaria.nome_fantasia
      end
      login     = current_user.login
      assunto   = params[:assunto]
      mensagem  = params[:mensagem]
      if Emailer.contact(imobiliaria, login, assunto, mensagem).deliver_now
        flash[:notice] = "Mensagem Enviada com sucesso!"
      else
        flash[:error] = "Falha ao enviar Mensagem!"
      end
    end
  end

  def sendmail
  end

  def coberturas_pendentes
    if Emailer.coberturas_pendentes.deliver_now
      render text: 'success'
    else
      render text: 'fail'
    end
  end
end
