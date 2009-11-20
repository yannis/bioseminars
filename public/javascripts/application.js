Array.prototype.index = function(val) {
  for(var i = 0, l = this.length; i < l; i++) {
    if(this[i] == val) return i;
  }
  return null;
}

Array.prototype.include = function(val) {
  return this.index(val) !== null;
}

// http://www.lalit.org/wordpress/wp-content/uploads/2008/06/cookiejar.js

var CookieJar = Class.create();

CookieJar.prototype = {

	/**
	 * Append before all cookie names to differntiate them.
	 */
	appendString: "__CJ_",

	/**
	 * Initializes the cookie jar with the options.
	 */
	initialize: function(options) {
		this.options = {
			expires: 3600,		// seconds (1 hr)
			path: '',			// cookie path
			domain: '',			// cookie domain
			secure: ''			// secure ?
		};
		Object.extend(this.options, options || {});

		if (this.options.expires != '') {
			var date = new Date();
			date = new Date(date.getTime() + (this.options.expires * 1000));
			this.options.expires = '; expires=' + date.toGMTString();
		}
		if (this.options.path != '') {
			this.options.path = '; path=' + escape(this.options.path);
		}
		if (this.options.domain != '') {
			this.options.domain = '; domain=' + escape(this.options.domain);
		}
		if (this.options.secure == 'secure') {
			this.options.secure = '; secure';
		} else {
			this.options.secure = '';
		}
	},

	/**
	 * Adds a name values pair.
	 */
	put: function(name, value) {
		name = this.appendString + name;
		cookie = this.options;
		var type = typeof value;
		switch(type) {
		  case 'undefined':
		  case 'function' :
		  case 'unknown'  : return false;
		  case 'boolean'  : 
		  case 'string'   : 
		  case 'number'   : value = String(value.toString());
		}
		var cookie_str = name + "=" + escape(Object.toJSON(value));
		try {
			document.cookie = cookie_str + cookie.expires + cookie.path + cookie.domain + cookie.secure;
		} catch (e) {
			return false;
		}
		return true;
	},

	/**
	 * Removes a particular cookie (name value pair) form the Cookie Jar.
	 */
	remove: function(name) {
		name = this.appendString + name;
		cookie = this.options;
		try {
			var date = new Date();
			date.setTime(date.getTime() - (3600 * 1000));
			var expires = '; expires=' + date.toGMTString();
			document.cookie = name + "=" + expires + cookie.path + cookie.domain + cookie.secure;
		} catch (e) {
			return false;
		}
		return true;
	},

	/**
	 * Return a particular cookie by name;
	 */
	get: function(name) {
		name = this.appendString + name;
		var cookies = document.cookie.match(name + '=(.*?)(;|$)');
		if (cookies) {
			return (unescape(cookies[1])).evalJSON();
		} else {
			return null;
		}
	},

	/**
	 * Empties the Cookie Jar. Deletes all the cookies.
	 */
	empty: function() {
		keys = this.getKeys();
		size = keys.size();
		for(i=0; i<size; i++) {
			this.remove(keys[i]);
		}
	},

	/**
	 * Returns all cookies as a single object
	 */
	getPack: function() {
		pack = {};
		keys = this.getKeys();

		size = keys.size();
		for(i=0; i<size; i++) {
			pack[keys[i]] = this.get(keys[i]);
		}
		return pack;
	},

	/**
	 * Returns all keys.
	 */
	getKeys: function() {
		keys = $A();
		keyRe= /[^=; ]+(?=\=)/g;
		str  = document.cookie;
		CJRe = new RegExp("^" + this.appendString);
		while((match = keyRe.exec(str)) != undefined) {
			if (CJRe.test(match[0].strip())) {
				keys.push(match[0].strip().gsub("^" + this.appendString,""));
			}
		}
		return keys;
	}
};

// Cookies (http://www.quirksmode.org/js/cookies.html)

function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  } else var expires = "";
  document.cookie = name+"="+encodeURIComponent(value)+expires+"; path=/";
}

function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
  }
  return null;
}

function eraseCookie(name) {
  createCookie(name,"",-1);
}

//#########

function set_datetime_blank(target_id) {
  var datetime_array = ['1i', '2i', '3i', '4i', '5i'];
  datetime_array.each( function(item) {
    $$('#'+target_id+'_'+item+' option').each(
      function(option){ option.selected = ''}
    )
  })
  return false;
}

function set_time_to_zero(target_id) {
  var datetime_array = ['4i', '5i'];
  datetime_array.each( function(item) {
    $$('#'+target_id+'_'+item+' option').each(
      function(option){ 
        if (option.value == '00') {
          option.selected = 'selected'}
      }
    )
  })
  return false;
}

// function all_day(target_id) {
//   if ($('seminar_all_day').checked==true) {
//     $(target_id).hide();
//     // set_time_to_zero(target_id);
//     // able_or_disable_datetime_select(target_id, '');
//     // set_datetime_blank(target_id);
//   } else {
//     $(target_id).show();
//     // able_or_disable_datetime_select(target_id, 'on');
//   }
// }
function all_day(target_ids_array) {
  target_ids_array.each(function(id){
    var t_field = $(id);
    var v = t_field.value;
    if (v != null) {
      var regexp = /\s\d\d:\d\d/;
      var cal_links = $$('img.calendar_date_select_popup_icon');
      if ($('seminar_all_day').checked==true && v.match(regexp)) {
        t_field.value = v.gsub(regexp,"");
        cal_links.each(function(i) {
          var oclick = i.readAttribute('onclick');
          if (oclick.match(' time:true,')) {
            i.setAttribute('onclick', oclick.gsub(' time:true,', ' time:false,'));
          }
        })
      } else if ($('seminar_all_day').checked==false && v != '' && v.match(regexp) == null) {
        t_field.value += ' 00:00';
        cal_links.each(function(i) {
          var oclick = i.readAttribute('onclick');
          if (oclick.match(' time:false,')) {
            i.setAttribute('onclick', oclick.gsub(' time:false,', ' time:true,'));
          }
        })
      }
    }
  })
}

function able_or_disable_datetime_select(target_id, value) {
  selects = $$('#'+target_id+' select');
  selects.each(function(item) {
    if (value == '') {item.disable()} else {item.enable()};
  })
}

function set_now(target_attribute) {
  var datetime_array = ['1i', '2i', '3i', '4i', '5i'];
  var dt = new Date();
  var hour = dt.getHours();
  if (hour < 10){ hour = "0" + hour };
  var min = dt.getMinutes();
  if (min < 10){ min = "0" + min };
  
  datetime_array.each(function(i) {
    select = $(target_attribute+'_'+i);
    switch (i)
    {
    case '1i':
      var t_time = dt.getFullYear();
      break;
    case '2i':
      var t_time = dt.getMonth()+1;
      break;
    case '3i':
      var t_time = dt.getDate();
      break;
    case '4i':
      var t_time = hour;
      break;
    case '5i':
      var t_time = min;
      break;
    default:
      var t_time = '';
    }
    var options = $A(select.options);
    options.each(function(option) {
      if (option.value == t_time) {option.selected = 'selected'} else {option.selected = null};
    })
  })
}


function able_or_disable_inputs_in_element(element_id, value) {
  selects = $$('#'+element_id+' select').concat($$('#'+element_id+" input[type='text']"));
  selects.each(function(item) {
    if (value == '1') {item.disable()} else {item.enable()};
  })
}

function copy_datetime(target_attribute, source_attribute) {
  var datetime_array = ['1i', '2i', '3i', '4i', '5i'];
  datetime_array.each(function(i) {
    target_select = $(target_attribute+'_'+i);
    source_select_value = $F(source_attribute+'_'+i);
    $A(target_select.options).each(function(option) {
      if (option.value == source_select_value) {option.selected = 'selected'} else {option.selected = null};
    })    
  })
}

function copy_text_field(target_element_id, source_element_id) {
  $(target_element_id).value = $F(source_element_id);
}


function confirm_destroy(element, action, auth_token) {
  if (confirm("Are you sure?")) {
    var f = document.createElement('form');
    f.style.display = 'none';
    element.parentNode.appendChild(f);
    f.method = 'POST';
    f.action = action;
    
    var m = document.createElement('input');
    m.setAttribute('type', 'hidden');
    m.setAttribute('name', '_method');
    m.setAttribute('value', 'delete');
    f.appendChild(m);
    
    var t = document.createElement('input'); 
    t.setAttribute('type', 'hidden'); 
    t.setAttribute('name', 'authenticity_token'); 
    t.setAttribute('value', auth_token); 
    f.appendChild(t);
    
    f.submit();
  }
  return false;
}

function remote_confirm_destroy(action, auth_token) {
  if (confirm('Are you sure?')) {
    new Ajax.Request(
      action, 
      {asynchronous:true, evalScripts:true, method:'delete', parameters:'authenticity_token=' + encodeURIComponent(auth_token)}
    )
  }
  return false;
}

function remove_div_and_restablish_opacity(target_id) {
  target = $(target_id);
  Effect.Fade(target, { duration: 1.0 });
  var opacity = $('main_container').getStyle('opacity');
  if (opacity != 1.0 && $$('.ajax_div').length==1) {
    new Effect.Opacity('main_container', { from: opacity, to: 1.0, duration: 1.0 });
  }
  setTimeout("Element.remove(target)", 1000);
}

function get_name_from_email(source, target) {
  email = $(source).value;
  if (email.match('@') != null) {
    var name_with_dot = email.split('@')[0];
    if (name_with_dot.match('.') != null) {
      var name = name_with_dot.gsub('.', ' ').gsub(/\w+/, function(i){return i[0].capitalize()});
    }
    $(target).value = name;
  }
}

function  set_new_seminar_function(auth_token){
  var tds = $$('table.calendar td.normalDay').concat($$('table.calendar td.specialDay'));
  tds.each(function(td){
    // td.setAttribute('ondblclick', "new_seminar('"+td.id+"', '"+auth_token+"' )");
    td.insert({top: "<span style='float: left; font-size: smaller; vertical-align: top'><a class='add_seminar_link' id='new_seminar_"+td.id+"' href='#' onclick=\"new_seminar('"+td.id+"\', \'"+auth_token+"\' ); return false;\" >(+)</a><img id='loader_new_seminar_"+td.id+"' style='display: none;' src='/images/ajax-loader.gif' alt='Ajax-loader'/></span>"});
  });
  
  // tds.each(function(item){
  //   alert(item.id);
  // });
}

function new_seminar(date, auth_token) {
  // if ($$('#'+date+' ul').length != 0) {
  //   var al = 'yes'
  // } else {
  //   var al = 'no'
  // }
  // alert(date+': '+al+': #'+date+' ul');
  Element.hide('new_seminar_'+date);
  Element.show('loader_new_seminar_'+date);
  new Ajax.Request('/seminars/new?origin='+date, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent(auth_token), onComplete:function(request){Element.hide('loader_new_seminar_'+date); Element.show('new_seminar_'+date)}});
  return false;
}


function copy(text) {
  if (window.clipboardData) {
    window.clipboardData.setData("Text",text);
  }
}

// function show_or_hide_internal_seminars(value) {
//   var semi_lis = $$('.seminar.internal');
//   semi_lis.each(function(li) {
//     if (value == 'true' && li.hasClassName('hidden_seminar')) {
//       li.removeClassName('hidden_seminar');
//       // li.show();
//     } else if (value != 'true' && !li.hasClassName('hidden_seminar')) {
//       li.addClassName('hidden_seminar');
//       // li.hide();
//     }
//   });
//   createCookie('display_int_seminar', value, 365);
// }

function show_or_hide_seminars_with_class(value, id) {
  jar = new CookieJar({
    expires:31536000,   // seconds
    path: '/'
  });
  
  if (jar.get('seminars_to_show')){
    seminars_to_show = jar.get('seminars_to_show');
  } else {
    seminars_to_show = []
  }
    
  if (jar.get('show_internal_seminars')){
    show_internal_seminars = jar.get('show_internal_seminars').include('true');
  } else {
    show_internal_seminars = false
  }
  
  if (id == 'internal') {
    var show_internal_seminars = (value == 'true')
    jar.put('show_internal_seminars', show_internal_seminars);
  } else {
    if (value == 'true') {
      if (!seminars_to_show.include(id)) { seminars_to_show.push(id) }
    } else {
      seminars_to_show = seminars_to_show.without(id);
    }
    jar.put('seminars_to_show', seminars_to_show);
  }
  var semi_lis = $$('.seminar');
  semi_lis.each(function(li) {
    var class_names = $w(li.className);
    var categ_id = class_names.toString().match(/category_\d+/)[0].match(/\d+/)[0];
  // alert(categ_id);
    if (seminars_to_show.include(categ_id)) {
      if (class_names.include('internal') && show_internal_seminars == false) {
        if (!class_names.include('hidden_seminar')) {
          li.addClassName('hidden_seminar');
        }
      } else {
        if (class_names.include('hidden_seminar')) {
          li.removeClassName('hidden_seminar');
        }
      }
    } else {
      if (!class_names.include('hidden_seminar')) {
        li.addClassName('hidden_seminar');
      }
    }
    
  // alert(categ_id);
  });
  // $('cookies_value').innerHTML = seminars_to_show;
}

function remove_field(element) {
  element.up().style.color = '#cc0000';
}

function show_hidden_categories() {
  $('categories').className = 'all_categories_shown';
}

function toggleVisibilityOfFormElement(element, link_element, text) {
  Effect.toggle(element, 'appear');
  if ($(link_element).innerHTML == '▼ '+text) { $(link_element).update('► '+text);
  } else { $(link_element).update('▼ '+text);
  }
}

function clearForm(form) {
  var elements = $A(form.elements);
  elements.each(function(elm) {
    if (elm.type == "text" || elm.type == "password" || elm.type == "textarea") {
      elm.value ='';
		} else if (elm.type == 'checkbox') {
		  elm.checked = false;
		} else if (elm.type == 'select') {
		  var options = $A(elm.options);
      options.each(function(option) {
        option.selected = null;
      })
		}
	})
}