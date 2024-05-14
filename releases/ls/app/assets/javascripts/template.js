$('select[data-dynamic-selectable-url][data-dynamic-selectable-target]').dynamicSelectable();

$('#tipo_de_documento_campo_documento_ids_').multiSelect();

$('#sindicato_cnpj').mask('99.999.999/9999-99');
/* MASK */
$('#corretora_codigo_sucursal').mask('99');
//$('#corretora_codigo_corretor').mask('99999');
//$('#corretora_codigo_colaborador').mask('99999');
$('#corretora_codigo_susep').mask('99999999999999');
//$('#corretora_codigo_da_inspetoria').mask('999999');
//$('#corretora_codigo_do_inspetor').mask('999999');
$('#corretora_cep').mask('99999-999');
$('#corretora_ddd').mask('99');
$('#corretora_telefone_corretor').mask('99999999');

$('#imobiliaria_telefone').mask('(99) 9999-9999');
$('#imobiliaria_celular').mask('(99) 9999-9999');
$('#imobiliaria_retorno').mask('99');
$('#imobiliaria_operacao').mask('9999');

var logradouro_cep = $('#logradouro_cep').val();
$('#logradouro_cep').mask('99999999');
$('.unmask').unmask();
$('#logradouro_cep').val(logradouro_cep);

$('#seguro_cep').mask('99999-999');

$('#titulo_cep').mask('99999-999');
$('#titulo_locatario_telefone').mask('(99) 9999-9999');


/* INICIO SEGURO FIANÇA */
$('#seguro_fianca_cep').mask('99999-999');
$('#seguro_fianca_valor_aluguel').priceFormat({ prefix: '', centsSeparator: ',', thousandsSeparator: '.' });
$('#seguro_fianca_valor_condominio').priceFormat({ prefix: '', centsSeparator: ',', thousandsSeparator: '.' });
$('#seguro_fianca_valor_iptu').priceFormat({ prefix: '', centsSeparator: ',', thousandsSeparator: '.' });
/* FINAL  SEGURO FIANÇA */


$(".datepicker").datepicker();
$('.datepicker').mask('99/99/9999');

$('#data_inicial').mask('99/99/9999');
$('#data_final').mask('99/99/9999');

function getMoney( str ) {
  return parseInt( str.replace(/[\D]+/g,'') );
}
function formatReal( int ) {
  var tmp = int+'';
  tmp = tmp.replace(/([0-9]{2})$/g, ",$1");
  if( tmp.length > 6 )
  tmp = tmp.replace(/([0-9]{3}),([0-9]{2}$)/g, ".$1,$2");

  return tmp;
}
$('#seguro_limite_maximo_indenizacao').priceFormat({
    prefix: '',
    centsSeparator: ',',
    thousandsSeparator: '.'
});
$('#titulo_valor_titulo').priceFormat({
    prefix: '',
    centsSeparator: ',',
    thousandsSeparator: '.'
});
$('#titulo_valor_locacao').priceFormat({
    prefix: '',
    centsSeparator: ',',
    thousandsSeparator: '.'
});

$( document ).ready(function() {
  $('#dataTable').DataTable( {
    language: {
      processing:     "Processando...",
      search:         "Pesquisar&nbsp;:",
      lengthMenu:     "Ver _MENU_ itens",
      info:           "Exibindo do item _START_ ao _END_ de _TOTAL_ ",
      infoEmpty:      "Exibindo do item 0 ao 0 de 0 ",
      infoFiltered:   "(filtrados _MAX_ itens do total)",
      infoPostFix:    "",
      loadingRecords: "Carregando...",
      zeroRecords:    "Nenhum item para consultar",
      emptyTable:     "Não existem dados disponíveis na tabela",
      paginate: {
          first:      "Primeiro",
          previous:   "Anterior",
          next:       "Próxima",
          last:       "Última"
      },
      aria: {
          sortAscending:  ": ordenar de forma crescente",
          sortDescending: ": ordenar de forma decrescente"
      }
    }
  });
});

$(document).ready(function() {
  $("a[data-confirm]").click(function(ev) {
    var href, method;
    href = $(this).attr("href");
    method = $(this).attr("data-method");
    submit = $(this).attr("data-submit");
    if (!$("#defaultmodal").length) {
      $("body .wrapper .content").append("<div class='modal fade in' id='defaultmodal' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='false' style='display: block; padding-right: 15px;'><div class='modal-backdrop fade in' style='height: 0px;'></div><div class='modal-dialog' style='margin-top: 10%; z-index:9999'><div class='modal-content'><div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-label='Cancelar'><span aria-hidden='true' class='ti-close'></span></button><h4 class='modal-title' id='myModalLabel'>Precisamos de sua Confirmação</h4></div><div class='modal-body' style='color: #000'></div><div class='modal-footer'><button type='button' class='btn btn-default float-left' data-dismiss='modal'>Cancelar</button><a href='#' type='button' class='btn btn-primary' id='dataConfirmOK'>Confirmar</button></div></div></div>");
    }
    $("#defaultmodal").find(".modal-body").text($(this).attr("data-confirm"));
    $("#dataConfirmOK").html(submit);
    $("#dataConfirmOK").attr("href", href);
    $("#dataConfirmOK").attr("data-method", method);
    $("#defaultmodal").modal({
      show: true
    });
    return false;
  });
  return $("input[data-confirm]").click(function(ev) {
    if (!$("#defaultmodal").length) {
      $(this).parents("form").append("<div class='modal fade in' id='defaultmodal' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='false' style='display: block; padding-right: 15px;'><div class='modal-backdrop fade in' style='height: 0px;'></div><div class='modal-dialog' style='margin-top: 10%; z-index:9999'><div class='modal-content'><div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-label='Cancelar'><span aria-hidden='true' class='ti-close'></span></button><h4 class='modal-title' id='myModalLabel'>Precisamos de sua Confirmação</h4></div><div class='modal-body' style='color: #000'><div class='modal-footer'><button type='button' class='btn btn-default float-left' data-dismiss='modal'>Cancelar</button><a href='#' type='button' class='btn btn-primary' id='dataConfirmOK'>Confirmar</button></div></div></div></div>");
    }
    $("#defaultmodal").find(".modal-body").text($(this).attr("data-confirm"));
    return false;
  });
});

$(document).keypress(function(e) {
  if (e.keyCode === 27) {
    $("#message_modal .close").click();
    return $("#defaultmodal").fadeOut("slow", function() {
      return $("#defaultmodal .close").click();
    });
  }
});

function only_numbers(event) {
  //alert(event.charCode);
  return (  (event.charCode >= 48 && event.charCode <= 57) && 
            (event.charCode != 9) && (event.charCode != 8) && 
            (event.charCode != 48) );
}