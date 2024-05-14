# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def flash_message(obj = nil)
    msg = ""
    if flash[:notice].present?
      msg ="<div class='alert alert-success'><strong>Informação:</strong> #{flash[:notice]}</div>"
    elsif flash[:alert].present?
      msg ="<div class='alert alert-warning'> <strong>Alerta:</strong> #{flash[:alert]}</div>"
    elsif flash[:error].present?
      flash[:error].split('<br/>').each do |error|
        msg += "<div class='alert alert-danger'> <strong>Erros:</strong> #{error}</div>"
      end
    elsif params[:info_mensagem].present?
      msg ="<div class='alert alert-success'> <strong>Nota:</strong> #{params[:info_mensagem]}</div>"
    elsif obj and !obj.errors.full_messages.blank?
      obj.errors.full_messages.uniq.each do |erro|
        msg += "<div class='alert alert-danger'> <strong>Erros:</strong> #{erro.to_s.gsub('base','')} </div>"
      end
    end
    flash[:notice] = flash[:alert] = flash[:error] = nil
    return ( render :inline => msg )
  end

  def tooltip_popover(msg = "")
    render inline: "<a data-content='#{msg}' 
                      data-placement='top' 
                      data-toggle='popover' 
                      data-trigger='hover'
                      style='margin-left: 8px;'>
                        <i class='fa fa-question-circle'></i>
                    </a>"
  end


  def cpf_cnpj_formatado(str)
    if str.size == 11
      Cpf.new(str).to_s
    else
      Cnpj.new(str).to_s
    end
  end

  def page_navigation_links(pages)
    will_paginate(pages, class:  'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
  end

  def options_estados
    Estado.order(:id).pluck(:nome, :id)
  end

  def options_yes_or_no
    [["SIM", true], ["NÃO", false]]
  end

  def options_estado_civil
    [
      ["Solteiro"],
      ["Casado"],
      ["Viúvo"],
      ["Separado"],
      ["Divorciado"],
      ["União Estavel"],
      ["Outros"]
    ]
  end

  def l(*args)
    if args.first.nil?
      return ''
    else
      super(*args)
    end
  end

  def template_label_tag(name)
    msg  = '<span class="input-group-btn">'
    msg += '  <button class="btn btn-info btn-lg" type="button" style="font-weight: bold">'
    msg += '    ' + name
    msg += '  </button>'
    msg += '</span>'
    msg.html_safe
  end

  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected
      def html_container(html)
        tag :div, tag(:ul, html, class: 'panel-body2'), container_attributes
      end

      def page_number(page)
        if page == current_page
          tag :li, link(page, "#", rel: rel_value(page), class: 'btn btn-default')
        else
          tag :li, link(page, page, rel: rel_value(page), class: 'btn btn-primary')
        end
      end

      def gap
        tag :li, link(super, '#'), class: 'uk-disabled'
      end

      def previous_or_next_page(page, text, classname)
        #if text == '&rarr;'
        #  tag :li, link(text, page || '#', class: 'uk-icon-angle-double-right'), class: [classname[0..3], classname, ('uk-disabled' unless page)].join(' ')
        #else
        if page
          tag :li, link(text, page || '#', class: 'btn btn-default', style: 'display: none')
        else
          tag :li, link(text, page || '#', class: 'btn btn-default btn-primary', style: 'display: none')
        end
        #end
      end
  end
  
  def get_alternate(init = nil)
    session[:alternate] = init if init
    session[:alternate] = 1    if session[:alternate].nil? 
    
    if session[:alternate] == 1 
       session[:alternate] = 2
       return "person_text"
    elsif session[:alternate] == 3
       session[:alternate] = 1
       return "person_text_small"
    else
       session[:alternate] = 1
       return "person_text_with_margin" 
    end
  end

  def meses
    [
      ['Janeiro'    ,1],
      ['Fevereiro'  ,2],
      ['Março'      ,3],
      ['Abril'      ,4],
      ['Maio'       ,5],
      ['Junho'      ,6],
      ['Julho'      ,7],
      ['Agosto'     ,8],
      ['Setembro'   ,9],
      ['Outubro'   ,10],
      ['Novembro'  ,11],
      ['Dezembro'  ,12]
    ]
  end

  def observe_field_js_click(observe, controller, action, with, update, min = nil, max = nil, error_msg = nil)
    retorno = ""
    count = 0
    dados = "'"
    variaveis = ""
    with.each do |w|
       variaveis += "var p_#{count}=jQuery('##{w.strip}').val();"
       dados += "#{w.strip}='+p_#{count}+'&"
       count += 1
    end

    condicao     = ''
    fim_condicao = ''
    if max and min and error_msg 
       condicao =  "
                    valor=parseFloat(jQuery('#seguro_limite_maximo_indenizacao').val().replace('.','').replace('.','').replace(',','.'));
                   "
       condicao += "if (valor > #{max}) {
                        $('##{error_msg}').html('Valor máximo é: R$ 2.000.000,00. ');
                    } else if ( valor < #{min}) {
                        var val_min = #{min > 30000.0 ? '"50.000,00"' : '"30.000,00"'};
                        $('##{error_msg}').html('Valor mínimo é: R$ '+ val_min + '.');
                    } else { 
                        $('##{error_msg}').html('');"
       fim_condicao = "}"
    end

       retorno += "jQuery('#{observe}').bind('click', function() {
          #{variaveis}
          dados=#{dados}';"
          #dados=#{dados}authenticity_token=#{session[:_csrf_token]}';"

       retorno += condicao

       retorno += "$.ajax({
             url: '/#{controller}/#{action}',
             global: false,
             type: 'post', 
             data: dados,
             dataType: 'html',
             processData: false,
             timeout: '9000',

             success: function(response) {
                $('#{update}').html(response);
             }
          });"
       retorno += fim_condicao
       retorno += "});"
    retorno
  end


  def observe_field_js(observe, controller, action, with, update, min = nil, max = nil, error_msg = nil)
    retorno = ""
    count = 0
    dados = "'"
    variaveis = ""
    with.each do |w|
       variaveis += "var p_#{count}=jQuery('##{w.strip}').val();"
       dados += "#{w.strip}='+p_#{count}+'&"
       count += 1
    end

    condicao     = ''
    fim_condicao = ''
    if max and min and error_msg 
       condicao =  "
                    valor=parseFloat(jQuery('#seguro_limite_maximo_indenizacao').val().replace('.','').replace('.','').replace(',','.'));
                   "
       condicao += "if (valor > #{max}) {
                        $('##{error_msg}').html('Valor máximo é: R$ 2.000.000,00. ');
                    } else if ( valor < #{min}) {
                        var val_min = #{min > 30000.0 ? '"50.000,00"' : '"30.000,00"'};
                        $('##{error_msg}').html('Valor mínimo é: R$ '+ val_min + '.');
                    } else { 
                        $('##{error_msg}').html('');"
       fim_condicao = "}"
    end

       retorno += "jQuery('#{observe}').bind('change', function() {
          #{variaveis}
          dados=#{dados}';"
          #dados=#{dados}authenticity_token=#{session[:_csrf_token]}';"

       retorno += condicao

       retorno += "$.ajax({
             url: '/#{controller}/#{action}',
             global: false,
             type: 'post', 
             data: dados,
             dataType: 'html',
             processData: false,
             timeout: '9000',

             success: function(response) {
                $('#{update}').html(response);
             }
          });"
       retorno += fim_condicao
       retorno += "});"
    retorno
  end


  def observe_field_atividade
  #dados='filtro='+p_0+'&authenticity_token=#{session[:_csrf_token]}';
     return "jQuery('#botao_atividade').click(function() {
                var p_0=jQuery('#filtro').val();
                dados='filtro='+p_0;

                if (jQuery('#filtro').val().length > 2 ){
                 $.ajax({
                   url: '/atividades/busca_atividades',
                   global: false,
                   type: 'post', 
                   data: dados,
                   dataType: 'html',
                   processData: false,
                   timeout: '9000',

                   success: function(response) {
                      $('#div_atividade').html(response);
                   }
                 });
               }
             });"
  end

  def row_alternate(init = nil)
    session[:alternate] = init if init
    session[:alternate] = 1    if session[:alternate].nil?

    if session[:alternate] == 1
       session[:alternate] = 2
       return "linha_par"
    else
       session[:alternate] = 1
       return "linha_impar"
    end
  end
end
