/*
 * jQuery UI @VERSION
 *
 * Copyright (c) 2008 Paul Bakaus (ui.jquery.com)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI
 */
;(function(b){function k(a){function c(a){a=a.style;return"none"!=a.display&&"hidden"!=a.visibility}var d=c(a);d&&b.each(b.dir(a,"parentNode"),function(){return d=c(this)});return d}function l(a,c,d,f){function g(d){d=b[a][c][d]||[];return"string"==typeof d?d.split(/,?\s+/):d}var e=g("getter");1==f.length&&"string"==typeof f[0]&&(e=e.concat(g("getterSetter")));return-1!=b.inArray(d,e)}var m=b.fn.remove;b.fn.remove=function(){b("*",this).add(this).each(function(){b(this).triggerHandler("remove")}); return m.apply(this,arguments)};b.extend(b.expr[":"],{data:function(a,c,d){return b.data(a,d[3])},tabbable:function(a){var b=a.nodeName.toLowerCase();return 0<=a.tabIndex&&("a"==b&&a.href||/input|select|textarea|button/.test(b)&&"hidden"!=a.type&&!a.disabled)&&k(a)}});b.keyCode={BACKSPACE:8,CAPS_LOCK:20,COMMA:188,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109, PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38};var j=b.browser.mozilla&&1.9>parseFloat(b.browser.version);b.fn.extend({ariaRole:function(a){return void 0!==a?this.attr("role",j?"wairole:"+a:a):(this.attr("role")||"").replace(/^wairole:/,"")},ariaState:function(a,c){return void 0!==c?this.each(function(d,f){j?f.setAttributeNS("http://www.w3.org/2005/07/aaa","aaa:"+a,c):b(f).attr("aria-"+a,c)}):this.attr(j?"aaa:"+a:"aria-"+a)}});b.widget=function(a,c){var d=a.split(".")[0], a=a.split(".")[1];b.fn[a]=function(c){var g="string"==typeof c,e=Array.prototype.slice.call(arguments,1);if(g&&"_"==c.substring(0,1))return this;if(g&&l(d,a,c,e)){var i=b.data(this[0],a);return i?i[c].apply(i,e):void 0}return this.each(function(){var h=b.data(this,a);!h&&!g&&b.data(this,a,new b[d][a](this,c));h&&g&&b.isFunction(h[c])&&h[c].apply(h,e)})};b[d]=b[d]||{};b[d][a]=function(c,g){var e=this;this.widgetName=a;this.widgetEventPrefix=b[d][a].eventPrefix||a;this.widgetBaseClass=d+"-"+a;this.options= b.extend({},b.widget.defaults,b[d][a].defaults,b.metadata&&b.metadata.get(c)[a],g);this.element=b(c).bind("setData."+a,function(a,b,c){return e._setData(b,c)}).bind("getData."+a,function(a,b){return e._getData(b)}).bind("remove",function(){return e.destroy()});this._init()};b[d][a].prototype=b.extend({},b.widget.prototype,c);b[d][a].getterSetter="option"};b.widget.prototype={_init:function(){},destroy:function(){this.element.removeData(this.widgetName)},option:function(a,c){var d=a,f=this;if("string"== typeof a){if(void 0===c)return this._getData(a);d={};d[a]=c}b.each(d,function(a,b){f._setData(a,b)})},_getData:function(a){return this.options[a]},_setData:function(a,b){this.options[a]=b;if("disabled"==a)this.element[b?"addClass":"removeClass"](this.widgetBaseClass+"-disabled")},enable:function(){this._setData("disabled",!1)},disable:function(){this._setData("disabled",!0)},_trigger:function(a,c,d){var f=a==this.widgetEventPrefix?a:this.widgetEventPrefix+a,c=c||b.event.fix({type:f,target:this.element[0]}); return this.element.triggerHandler(f,[c,d],this.options[a])}};b.widget.defaults={disabled:!1}})(jQuery);


/*
 * jQuery UI Spinner @VERSION
 *
 * Copyright (c) 2008 jQuery
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Spinner
 *
 * Depends:
 *  ui.core.js
 */
;(function(d){d.widget("ui.spinner",{_init:function(){this._trigger("init",null,this.ui(null));if("object"==typeof this.options.items[0]&&!this.element.is("input"))for(var a=this.options.items,c=0;c<a.length;c++)this._addItem(a[c]);this._decimals=parseInt(this.options.decimals,10);-1!=this.options.stepping.toString().indexOf(".")&&(a=this.options.stepping.toString(),this._decimals=a.slice(a.indexOf(".")+1,a.length).length);var b=this;this.element.addClass("ui-spinner-box").attr("autocomplete","off"); this._setValue(isNaN(this._getValue())?this.options.start:this._getValue());this.element.wrap("<div>").parent().addClass("ui-spinner").append('<button class="ui-spinner-up" type="button"></button>').find(".ui-spinner-up").bind("mousedown",function(a){d(this).addClass("ui-spinner-pressed");if(!b.counter)b.counter=1;b._mousedown(100,"_up",a)}).bind("mouseup",function(a){d(this).removeClass("ui-spinner-pressed");b.counter==1&&b._up(a);b._mouseup(a)}).bind("mouseout",function(a){d(this).removeClass("ui-spinner-pressed"); b.timer&&b._mouseup(a)}).bind("dblclick",function(a){d(this).removeClass("ui-spinner-pressed");b._up(a);b._mouseup(a)}).bind("keydown.spinner",function(a){var c=d.keyCode;if(a.keyCode==c.SPACE||a.keyCode==c.ENTER){d(this).addClass("ui-spinner-pressed");if(!b.counter)b.counter=1;b._up.call(b,a)}else a.keyCode==c.DOWN||a.keyCode==c.RIGHT?b.element.siblings(".ui-spinner-down").focus():a.keyCode==c.LEFT&&b.element.focus()}).bind("keyup.spinner",function(a){d(this).removeClass("ui-spinner-pressed");b.counter= 0;b._propagate("change",a)}).end().append('<button class="ui-spinner-down" type="button"></button>').find(".ui-spinner-down").bind("mousedown",function(a){d(this).addClass("ui-spinner-pressed");if(!b.counter)b.counter=1;b._mousedown(100,"_down",a)}).bind("mouseup",function(a){d(this).removeClass("ui-spinner-pressed");b.counter==1&&b._down();b._mouseup(a)}).bind("mouseout",function(a){d(this).removeClass("ui-spinner-pressed");b.timer&&b._mouseup(a)}).bind("dblclick",function(a){d(this).removeClass("ui-spinner-pressed"); b._down(a);b._mouseup(a)}).bind("keydown.spinner",function(a){var c=d.keyCode;if(a.keyCode==c.SPACE||a.keyCode==c.ENTER){d(this).addClass("ui-spinner-pressed");if(!b.counter)b.counter=1;b._down.call(b,a)}else(a.keyCode==c.UP||a.keyCode==c.LEFT)&&b.element.siblings(".ui-spinner-up").focus()}).bind("keyup.spinner",function(a){d(this).removeClass("ui-spinner-pressed");b.counter=0;b._propagate("change",a)}).end();this._items=this.element.children().length;1<this._items&&(a=this.element.outerHeight()/ this._items,this.element.addClass("ui-spinner-list").height(a).children().addClass("ui-spinner-listitem").height(a).css("overflow","hidden").end().parent().height(a).end(),this.options.stepping=1,this.options.min=0,this.options.max=this._items-1);this.element.bind("keydown.spinner",function(a){if(!b.counter)b.counter=1;return b._keydown.call(b,a)}).bind("keyup.spinner",function(a){b.counter=0;b._propagate("change",a)}).bind("blur.spinner",function(){b._cleanUp()});d.fn.mousewheel&&this.element.mousewheel(function(a, c){b._mousewheel(a,c)})},_constrain:function(){void 0!=this.options.min&&this._getValue()<this.options.min&&this._setValue(this.options.min);void 0!=this.options.max&&this._getValue()>this.options.max&&this._setValue(this.options.max)},_cleanUp:function(){this._setValue(this._getValue());this._constrain()},_spin:function(a,c){this.disabled||(isNaN(this._getValue())&&this._setValue(this.options.start),this._setValue(this._getValue()+("up"==a?1:-1)*(this.options.incremental&&100<this.counter?200<this.counter? 100:10:1)*this.options.stepping),this._animate(a),this._constrain(),this.counter&&this.counter++,this._propagate("spin",c))},_down:function(a){this._spin("down",a);this._propagate("down",a)},_up:function(a){this._spin("up",a);this._propagate("up",a)},_mousedown:function(a,c,b){var d=this,a=a||100;this.timer&&(window.clearInterval(this.timer),this.timer=0);this.timer=window.setInterval(function(){d[c](b);d.counter>20&&d._mousedown(20,c,b)},a)},_mouseup:function(a){this.counter=0;this.timer&&(window.clearInterval(this.timer), this.timer=0);this.element[0].focus();this._propagate("change",a)},_keydown:function(a){var c=d.keyCode;a.keyCode==c.UP&&this._up(a);a.keyCode==c.DOWN&&this._down(a);a.keyCode==c.HOME&&this._setValue(this.options.min||this.options.start);a.keyCode==c.END&&void 0!=this.options.max&&this._setValue(this.options.max);return a.keyCode==c.TAB||a.keyCode==c.BACKSPACE||a.keyCode==c.LEFT||a.keyCode==c.RIGHT||a.keyCode==c.PERIOD||a.keyCode==c.NUMPAD_DECIMAL||a.keyCode==c.NUMPAD_SUBTRACT||96<=a.keyCode&&105>= a.keyCode||/[0-9\-\.]/.test(String.fromCharCode(a.keyCode))?!0:!1},_mousewheel:function(a,c){var b=this,c=d.browser.opera?-c/Math.abs(c):c;0<c?b._up(a):b._down(a);b.timeout&&(window.clearTimeout(b.timeout),b.timeout=0);b.timeout=window.setTimeout(function(){b._propagate("change",a)},400);a.preventDefault()},_getValue:function(){return parseFloat(this.element.val().replace(/[^0-9\-\.]/g,""))},_setValue:function(a){isNaN(a)&&(a=this.options.start);this.element.val(this.options.currency?d.ui.spinner.format.currency(a, this.options.currency):d.ui.spinner.format.number(a,this._decimals))},_animate:function(a){this.element.hasClass("ui-spinner-list")&&("up"==a&&this._getValue()<=this.options.max||"down"==a&&this._getValue()>=this.options.min)&&this.element.animate({marginTop:"-"+this._getValue()*this.element.parent().height()},{duration:"fast",queue:!1})},_addItem:function(a,c){if(!this.element.is("input")){var b="div";if(this.element.is("ol")||this.element.is("ul"))b="li";var d=a;"object"==typeof a&&(d=(void 0!== c?c:this.options.format).replace(/%(\(([^)]+)\))?/g,function(a){return function(b,c,d){if(d)return a[d];for(var e in a)return a[e]}}(a)));this.element.append("<"+b+' class="ui-spinner-data">'+d+"</"+b+">")}},plugins:{},ui:function(){return{options:this.options,element:this.element,value:this._getValue(),add:this._addItem}},_propagate:function(a,c){d.ui.plugin.call(this,a,[c,this.ui()]);return this.element.triggerHandler("spin"==a?a:"spin"+a,[c,this.ui()],this.options[a])},destroy:function(){d.data(this.element[0], "spinner")&&(d.fn.mousewheel&&this.element.unmousewheel(),this.element.removeClass("ui-spinner-box ui-spinner-list").removeAttr("disabled").removeAttr("autocomplete").removeData("spinner").unbind(".spinner").siblings().remove().end().children().removeClass("ui-spinner-listitem").remove(".ui-spinner-data").end().parent().removeClass("ui-spinner ui-spinner-disabled").before(this.element.clone()).remove().end())},enable:function(){this.element.removeAttr("disabled").siblings().removeAttr("disabled").parent().removeClass("ui-spinner-disabled"); this.disabled=!1},disable:function(){this.element.attr("disabled",!0).siblings().attr("disabled",!0).parent().addClass("ui-spinner-disabled");this.disabled=!0}});d.extend(d.ui.spinner,{defaults:{decimals:0,stepping:1,start:0,incremental:!0,currency:!1,format:"%",items:[]},format:{currency:function(a,c){a=isNaN(a)?0:a;return(a!==Math.abs(a)?"-":"")+c+this.number(Math.abs(a),2)},number:function(a,c){for(var b=/(\d+)(\d{3})/,a=isNaN(a)?0:parseFloat(a,10).toFixed(c);b.test(a);a=a.replace(b,"$1,$2")); return a}}})})(jQuery);

/*! Copyright (c) 2011 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 * Thanks to: Seamus Leahy for adding deltaX and deltaY
 *
 * Version: 3.0.6
 * 
 * Requires: 1.2.2+
 */
;(function(a){function d(b){var c=b||window.event,d=[].slice.call(arguments,1),e=0,f=!0,g=0,h=0;return b=a.event.fix(c),b.type="mousewheel",c.wheelDelta&&(e=c.wheelDelta/120),c.detail&&(e=-c.detail/3),h=e,c.axis!==undefined&&c.axis===c.HORIZONTAL_AXIS&&(h=0,g=-1*e),c.wheelDeltaY!==undefined&&(h=c.wheelDeltaY/120),c.wheelDeltaX!==undefined&&(g=-1*c.wheelDeltaX/120),d.unshift(b,e,g,h),(a.event.dispatch||a.event.handle).apply(this,d)}var b=["DOMMouseScroll","mousewheel"];if(a.event.fixHooks)for(var c=b.length;c;)a.event.fixHooks[b[--c]]=a.event.mouseHooks;a.event.special.mousewheel={setup:function(){if(this.addEventListener)for(var a=b.length;a;)this.addEventListener(b[--a],d,!1);else this.onmousewheel=d},teardown:function(){if(this.removeEventListener)for(var a=b.length;a;)this.removeEventListener(b[--a],d,!1);else this.onmousewheel=null}},a.fn.extend({mousewheel:function(a){return a?this.bind("mousewheel",a):this.trigger("mousewheel")},unmousewheel:function(a){return this.unbind("mousewheel",a)}})})(jQuery)

