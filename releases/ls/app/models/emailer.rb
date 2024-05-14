class Emailer < ActionMailer::Base
  default from: "webtecm@gmail.com" # "no-reply@webtecmaster.com.br"

  CONTATO = 'paulohenrique@webtecmaster.com.br'
  def contact(imobiliaria, login, assunto, mensagem) #, sent_at = Time.now)
    @imobiliaria = imobiliaria
    @login       = login
    @subject     = "Fale Conosco - Seguros"
    @assunto     = assunto
    @mensagem    = mensagem
=begin
    @recipients = 'comercial@webtecmaster.com.br'
    @from = 'no-reply@webtecmaster.com.br'
    @sent_on = sent_at
        @body["title"] = 'Fale Conosco - Seguros'
        @body["email"] = CONTATO
  	      @body["message"] = mensagem
    @headers = {}
=end
    mail(to: CONTATO, subject: 'Fale Conosco - Seguros')
  end

  def coberturas_pendentes
    @resultado = Seguro.find_by_sql("SELECT i.estipulante,
                                          CASE s.tipo_de_seguro
                                              WHEN 'C'::text THEN 'EMPRESARIAL'::text
                                              WHEN 'R'::text THEN 'RESIDENCIAL'::text
                                              ELSE NULL::text
                                          END AS tipo_de_seguro,
                                      count(s.id) AS quantidade
                                     FROM seguros s
                                       JOIN imobiliarias i ON i.id = s.imobiliaria_id
                                    WHERE s.status = 1
                                    GROUP BY i.estipulante, s.tipo_de_seguro
                                    ORDER BY 1,
                                          CASE s.tipo_de_seguro
                                              WHEN 'C'::text THEN 'EMPRESARIAL'::text
                                              WHEN 'R'::text THEN 'RESIDENCIAL'::text
                                              ELSE NULL::text
                                          END;")

    mail(to: CONTATO, subject: 'Relatório Diário de Coberturas Pendentes')
  end

  def novo_titulo(id, email)
    @titulo = Titulo.find(id)
    mail(to: email, subject: 'Novo Título Cadastrado')
  end

  def novo_seguro_fianca(id, email)
    @seguro_fianca = SeguroFianca.find(id)
    mail(to: email, subject: 'Novo Segurço Fiança Cadastrado')
  end
=begin
  def relatorio(email, resultado, sent_at = Time.now)
    assunto = 'Relatório Diário de Coberturas Pendentes'
    @resultado = resultado
    @subject = assunto
    @assunto = assunto
    @recipients = email
    @from = 'no-reply@webtecmaster.com.br'
    @sent_on = sent_at
        @body["title"] = assunto
        @body["email"] = email
    @headers = {}
  end
=end
end
