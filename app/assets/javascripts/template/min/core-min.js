"use strict";$(document).ready(function(){var e=$(".left-bar").niceScroll();if($(".menu-bar").click(function(){$(".wrapper").toggleClass("mini-bar"),$(".left-bar").getNiceScroll().remove(),setTimeout(function(){$(".left-bar").niceScroll()},200)}),$(".menu-bar-mobile").on("click",function(e){$(".left-bar").getNiceScroll().remove(),$(".left-bar").toggleClass("menu_appear"),$(".overlay").toggleClass("show"),setTimeout(function(){$(".left-bar").niceScroll()},200)}),$(".overlay").on("click",function(){$(".left-bar").toggleClass("menu_appear"),$(this).removeClass("show")}),$(".right-bar-toggle").on("click",function(e){e.preventDefault(),$(".wrapper").toggleClass("right-bar-enabled")}),$("ul.menu-parent").accordion(),(new WOW).init(),$(".panel-close").on("click",function(e){e.preventDefault(),$(this).parent().parent().parent().parent().addClass(" animated fadeOutDown")}),$(".panel-minimize").on("click",function(e){e.preventDefault();var l=$(this).parent().parent().parent().next(".panel-body");l.is(":visible")?$("i",$(this)).removeClass("ti-angle-up").addClass("ti-angle-down"):$("i",$(this)).removeClass("ti-angle-down").addClass("ti-angle-up"),l.slideToggle()}),$(".panel-refresh").on("click",function(e){e.preventDefault();var l=$(this).closest(".panel-heading").next(".panel-body");l.mask('<i class="fa fa-refresh fa-spin"></i> Loading...'),setTimeout(function(){l.unmask(),console.log("ended")},1e3)}),!$(".wrapper").hasClass("mini-bar")&&$(window).width()>1200){$(".submenu li.active").closest(".submenu").addClass("current");var l=$(".submenu li.current").closest("ul").css("display","block")}if($(".mail_list").length>0&&$(".mail_list").niceScroll(),$(".mails_holder").length>0&&$(".mails_holder").niceScroll(),$(".mail_brief_holder").length>0&&$(".mail_brief_holder").niceScroll(),$("#paginator").length>0&&$("#paginator").datepaginator(),$(".table-row").length>0&&$(".table-row").on("click",function(){$(this).toggleClass("active")}),$(".pick-a-color").length>0&&$(".pick-a-color").pickAColor({showSpectrum:!0,showSavedColors:!0,saveColorsPerElement:!0,fadeMenuToggle:!0,showAdvanced:!0,showBasicColors:!0,showHexInput:!0,allowBlank:!0,inlineDropdown:!0}),$("#colorPicker").length>0){var t=$("#colorPicker");t.tinycolorpicker()}$("#picker").length>0&&$("#picker").colpick({flat:!0,layout:"hex",submit:0});var n="June 7, 2087 15:03:25";$(".countdown.styled").length>0&&$(".countdown.styled").countdown({date:n,render:function(e){$(this.el).html("<div>"+this.leadingZeros(e.years,2)+" <span>years</span></div><div>"+this.leadingZeros(e.days,2)+" <span>days</span></div><div>"+this.leadingZeros(e.hours,2)+" <span>hrs</span></div><div>"+this.leadingZeros(e.min,2)+" <span>min</span></div><div>"+this.leadingZeros(e.sec,2)+" <span>sec</span></div>")}}),$(".openNav").length>0&&$(".openNav").click(function(){$(this).toggleClass("open")}),$("#elm1").length>0&&tinymce.init({selector:"textarea#elm1",theme:"modern",height:300,plugins:["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker","searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking","save table contextmenu directionality emoticons template paste textcolor"],toolbar:"insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | l      ink image | print preview media fullpage | forecolor backcolor emoticons",style_formats:[{title:"Bold text",inline:"b"},{title:"Red text",inline:"span",styles:{color:"#ff0000"}},{title:"Red header",block:"h1",styles:{color:"#ff0000"}},{title:"Example 1",inline:"span",classes:"example1"},{title:"Example 2",inline:"span",classes:"example2"},{title:"Table styles"},{title:"Table row 1",selector:"tr",classes:"tablerow1"}]})});