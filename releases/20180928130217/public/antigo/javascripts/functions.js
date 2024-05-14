function verificaNumero(e) {
   if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
      return false;
   }
}
jQuery(function($){
   $("#seguro_numero").keypress(verificaNumero);
   $("#seguro_limite_maximo_indenizacao").maskMoney({ decimal:",", thousands:".", precision: 2 });
   $("#seguro_numero").keypress(verificaNumero);
   $("#seguro_cep").mask("99999-999");
   $("#seguro_numero").keypress(verificaNumero);

   //$('#seguro_inquilino').filter_input({regex:'[A-Z|\s]'});
   $('#seguro_inquilino').keyup(function(e){
     var str=$('#seguro_inquilino').val(); // + String.fromCharCode(e.keyCode);
     var format='';
     var code=0;
     for ( var i = 0; i < str.length; i++ ){
        code=str[i].charCodeAt();
        if ((code < 91 && code > 64) || (code > 96 && code < 123) || code == 32 || (code < 58 && code > 47)){
           if (code > 96 && code < 123) {  
             format += String.fromCharCode(code -32 );
           } else { 
             format += str[i]; 
           }
        }
     }

     $('#seguro_inquilino').val(format);
     return false;
   });


   $('#seguro_proprietario').keyup(function(e){
     var str=$('#seguro_proprietario').val(); // + String.fromCharCode(e.keyCode);
     var format='';
     var code=0;
     for ( var i = 0; i < str.length; i++ ){
        code=str[i].charCodeAt();
        if ((code < 91 && code > 64) || (code > 96 && code < 123) || code == 32 || (code < 58 && code > 47)){
           if (code > 96 && code < 123) {  
             format += String.fromCharCode(code -32 );
           } else { format += str[i]; }
        }
     }
     $('#seguro_proprietario').val(format);
     return false;
   });


    $('#seguro_complemento').keyup(function(e){
      var str=$('#seguro_complemento').val(); // + String.fromCharCode(e.keyCode);
      var format='';
      var code=0;
      for ( var i = 0; i < str.length; i++ ){
        code=str[i].charCodeAt();
        if ((code < 91 && code > 64) || (code > 96 && code < 123) || code == 32 || (code < 58 && code > 47)){
          if (code > 96 && code < 123) {
            format += String.fromCharCode(code -32 ); 
          } else { 
            format += str[i]; 
          }
        }
      }
      $('#seguro_complemento').val(format);
      return false;
    });
});
