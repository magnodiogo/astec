class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:site]
  def index
    if current_user.imobiliaria_id
      cond = "inicio <= current_date and fim >= current_date"
      @mensagem   = current_user.mensagens.where(ativo: true).where(cond).last
      @mensagem ||= current_user.imobiliaria.mensagens.where(ativo: true).where(cond).last
    end
  end

  def menu
  end

  def site 
    if params[:p] == '01'
      @title =  'Riscos Patrimoniais'
      @desc  =  "A Tec Master Corretora de Seguros com a garantia de grandes seguradoras nacionais e internacionais inova o mercado de seguros e elabora produtos especiais para garantir o seu patrimônio. Além disso, oferece coberturas diversas com assistência 24h personalizada para vários serviços emergenciais. A Tec Master administra seu risco, entregando sempre o que há de melhor na busca da sua satisfação e tranqüilidades."
    elsif params[:p] == '02'
      @title = 'Riscos Aeronáuticos'
      @desc  = "A Tec Master Corretora de Seguros com a garantia de grandes seguradoras nacionais e internacionais, presta consultoria para contratação de seguro aeronáutico, com o objetivo de indenizar prejuízos sofridos, reembolsos de despesas e responsabilidades legais e a que vier a ser obrigado, em decorrência da utilização da aeronave segurada."
    elsif params[:p] == '03'
      @title = 'Riscos de Transporte'
      @desc  = "A Tec Master Corretora de Seguros com a garantia de grandes seguradoras nacionais e internacionais, presta consultoria para contratação de seguros de transportes com o objetivo de indenizar prejuízos decorrentes de riscos ligados ao transporte de cargas aéreas, terrestres, fluvial, marítimo e ferroviário. Garantindo a sua tranqüilidade na entrega de suas mercadorias."
    elsif params[:p] == '04'
      @title = 'Riscos de Vida em Grupo'
      @desc  = "A Tec Master Corretora de Seguros com a garantia de grandes seguradoras nacionais e internacionais, presta consultoria para contratação de seguros de vida em grupo. A motivação e valorização dos seus profissionais são as ferramentas mais eficazes nas melhores empresas, visando sempre a garantia qualidade no trabalho, nos serviços e no atendimento prestado aos seus clientes."
    elsif params[:p] == '05'
      @title = 'Riscos Ambientais'
      @desc  = "A Tec Master Corretora de Seguros com a garantia de grandes seguradoras nacionais e internacionais, presta consultoria para contratação de seguros de riscos ambientais com o objetivo de indenizar, em casos de poluição súbita, poluição gradual, despesas de contenção de desastres ambientais e medidas emergenciais tomadas diante de um incidente ocorrido, evitando o sinistro de poluição ambiental propriamente dito, honorários advocatícios e custas judiciais para a defesa do segurado."
      @obs   = "“Todos têm direito ao meio ambiente ecologicamente equilibrado, vem de uso comum do povo e essencial à sadia qualidade de vida, impondo-se ao poder público e à coletividade o dever de defende-lo e preservá-lo para as presentes e futuras gerações.” (Art 225 da Constituição Federal do Brasil)"
    end                  
    render layout: false
  end
end
