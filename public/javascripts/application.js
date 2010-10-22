$(function() {
  try{Typekit.load();}catch(e){};
  insert_loaders();
  insert_close_button_in_flash();
  watch_all_day();
  check_pubmed_ids();
})

$('.seminar_link').each( function() {
  $(this).qtip({
    content: { 
      text: $(this).next('.mini_seminar'),
      title: { 
        text: $(this).attr('title'),
        button: 'x'
      }
    },
    style: {
      classes: 'my_qtip_style'
    },
    position: {
      my: 'left center', 
      at: 'right center'
    },
    show: {
      event: 'click',
      solo: true
    },
    hide: {
      fixed: true,
      event: false
    }
  })
})

function insert_loaders() { 
  $('a[data-remote=true]').each(function() {
    if (!$(this).next('img').hasClass('ajax_loader')) {
      var element_id = $(this).attr('id');
      $(this).after("<img src='/images/ajax-loader.gif' class='ajax_loader' id='"+element_id+"_ajax_loader' style='display: none'/>");
      $(this).bind('click', function() {
        $(this).hide();
        $(this).next('img').show();
      });
    }
  })
  
  $('input[type=submit]').each(function() {
    if (!$(this).next('img').hasClass('ajax_loader_large')) {
      $(this).after("<img src='/images/ajax-loader-large.gif' class='ajax_loader_large' style='display: none'/>");
      $(this).bind('click', function() {
        $(this).hide();
        $(this).next('img').show();
      });
    }
  })
}

function insert_loader_image_after(element_id) {
  $('#'+element_id).after("<img src='/images/ajax-loader.gif' class='ajax_loader' id='"+element_id+"_ajax_loader' style='display: none'/>")
}

function insert_close_button_in_flash() {
  $('#flash_and_co div[id^=flash_]').prepend($("<img class='flash_close' width='30' height='30' border='0' src='/images/closebox.png' />"));
  $('.flash_close').bind('click', function() {
    $(this).parent().fadeOut();
  });
}

function hide_ajax_loader() {
  $(".ajax_loader:visible").each(function() {
    $(this).hide();
    $(this).prev().show();
  })
}

function show_hide_categories() {
  $('#categories input[type=checkbox].categories_cb').click(function() {
    show_or_hide_seminars_with_class( $(this).attr('value'), $(this).attr('checked') ) 
  });
  $('#categories #ZoomClose, #categories #show_all_categories').click(function() {
    $('#categories').toggleClass( 'all_categories_shown categories_hidden' );
    if ($('#categories').hasClass('categories_hidden')) {
      $('#categories #show_all_categories').html('Display all categories')
    } else {
      $('#categories #show_all_categories').html('Close')
    };
    return false;
  });
  var check_all_link = $("<a href='#'>Check all</a>");
  $('#categories .admin_links').prepend(' · ');
  $('#categories .admin_links').prepend(check_all_link);
  check_all_link.click(function() {
    $('#categories input[type=checkbox].categories_cb').attr('checked', 'checked');
    $('#categories input[type=checkbox].categories_cb').each(function() {
      show_or_hide_seminars_with_class( $(this).attr('value'), true ) 
    })
    return false;
  });
  var uncheck_all_link = $("<a href='#'>Uncheck all</a>");
  $('#categories .admin_links').prepend(' · ');
  $('#categories .admin_links').prepend(uncheck_all_link);
  uncheck_all_link.click(function() {
    $('#categories input[type=checkbox]').attr('checked', '');
    $('#categories input[type=checkbox].categories_cb').each(function() {
      show_or_hide_seminars_with_class( $(this).attr('value'), '' ) 
    })
    return false;
  });
}

function show_or_hide_seminars_with_class(id, checked) {
  var seminars_to_show = [];
  if ($.cookie('seminars_to_show')) { seminars_to_show = jQuery.parseJSON($.cookie('seminars_to_show'))  };
  if (checked == true) {
    if (!seminars_to_show.include(id)) { seminars_to_show.push(id) }
  } else {
    seminars_to_show = jQuery.grep(
      seminars_to_show, function(n,i) {
        return n != id;
      }
    )
  }
  $.cookie('seminars_to_show', jQuery.toJSON(seminars_to_show), { expires: 365 });
  var semi_lis = $('.seminar');
  semi_lis.each( 
    function(i) {
      var class_names = $(this).attr('class');
      var categ_id = $(this).attr('class').match(/category_\d+/)[0].match(/\d+/)[0];
      if (seminars_to_show.include(categ_id)) {
        if (class_names.match('internal')) {
          if (seminars_to_show.include('internal')) {
            if (class_names.match('hidden_seminar')) {
              $(this).removeClass('hidden_seminar');
            }
          } else {
            if (!class_names.match('hidden_seminar')) {
              $(this).addClass('hidden_seminar');
            }
          }
        } else {
          if (class_names.match('hidden_seminar')) {
            $(this).removeClass('hidden_seminar');
          }
        }
      } else {
        if (!class_names.match('hidden_seminar')) {
          $(this).addClass('hidden_seminar');
        }
      }
    }
  )
}

function watch_all_day() {
  var date_text_fields = $('input.date_selector_field');
  date_text_fields.datetimepicker({dateFormat: 'dd/mm/yy'});
  var check_box = $('#seminar_all_day');
  if (check_box.length == 0) {
    date_text_fields.datetimepicker({dateFormat: 'dd/mm/yy'});
  } else {
    if (check_box.is(':checked')) {
      date_text_fields.datepicker({dateFormat: 'dd/mm/yy'});
    } else {
      date_text_fields.datetimepicker({dateFormat: 'dd/mm/yy'});
    };
    check_box.change(function() {
      if ($(this).is(':checked')) {
        date_text_fields.datepicker('destroy');
        date_text_fields.datepicker({dateFormat: 'dd/mm/yy'});
        date_text_fields.each(function() {
          $(this).val($(this).val().split(' ')[0]);
        })
      } else {
        date_text_fields.datepicker('destroy');
        date_text_fields.datetimepicker({dateFormat: 'dd/mm/yy'});
        date_text_fields.each(function() {
          $(this).val($(this).val()+' 12:00');
        })
      }
    })
  }
}

function show_hidden_categories() {
  $('#categories').toggleClass( 'all_categories_shown' );
}

function set_colorpicker(color) {
  $('#category_color').css('background-color', '#'+color);
  $('#category_color').ColorPicker({
  	color: 'color', 
  	onShow: function (colpkr) {
  		$(colpkr).fadeIn(500);
  		return false;                                                          
  	},                                                                       
  	onHide: function (colpkr) {                                              
  		$(colpkr).fadeOut(500);                                                
  		return false;                                                          
  	},                                                                       
  	onChange: function (hsb, hex, rgb) {                                     
  		$('#category_color').css('background-color', '#' + hex);               
  		$('#category_color').val(hex);                                         
  	}                                                                        
  })
}

Array.prototype.index = function(val) {
  for(var i = 0, l = this.length; i < l; i++) {
    if(this[i] == val) return i;
  }
  return null;
}

Array.prototype.include = function(val) {
  return this.index(val) !== null;
}

// Overlay
function add_overlay(modalbox_id) {
  if ($('#black_overlay').length != 0) {
    var black_overlay = $('#black_overlay');
    if (black_overlay.css('display') == 'none') {
      black_overlay.fadeIn(800);
    }
  } else {
    var black_overlay = $("<div id='black_overlay' style='display: none'></div>");
    black_overlay.bind('click', function() {
      remove_div_and_overlay(modalbox_id);
    });
    $('body').prepend(black_overlay);
    black_overlay.fadeIn(800);
  }
  $('#'+modalbox_id).fadeIn(800);
  hide_ajax_loader();
}

function remove_div_and_overlay(target_id) {
  var number_of_ajax_div = $('.ajax_div').length;
  var target = $('#'+target_id);
  var black_overlay = $('#black_overlay');
  target.fadeOut(800).delay(800).remove();
  if (number_of_ajax_div == 1) {
    black_overlay.fadeOut(800);
  }
}

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
  var d = new Date();
  var curr_date = d.getDate();
  if (curr_date < 10){ curr_date = "0" + curr_date };
  var curr_month = d.getMonth()+1;
  var curr_year = d.getFullYear();
  var hour = d.getHours();
  if (hour < 10){ hour = "0" + hour };
  var min = d.getMinutes();
  if (min < 10){ min = "0" + min };
  $(target_attribute).val(curr_date+'/'+curr_month+'/'+curr_year+' '+hour+':'+min)
}

// function set_now(target_attribute) {
//   var datetime_array = ['1i', '2i', '3i', '4i', '5i'];
//   var dt = new Date();
//   
//   datetime_array.each(function(i) {
//     select = $(target_attribute+'_'+i);
//     switch (i)
//     {
//     case '1i':
//       var t_time = dt.getFullYear();
//       break;
//     case '2i':
//       var t_time = dt.getMonth()+1;
//       break;
//     case '3i':
//       var t_time = dt.getDate();
//       break;
//     case '4i':
//       var t_time = hour;
//       break;
//     case '5i':
//       var t_time = min;
//       break;
//     default:
//       var t_time = '';
//     }
//     var options = $A(select.options);
//     options.each(function(option) {
//       if (option.value == t_time) {option.selected = 'selected'} else {option.selected = null};
//     })
//   })
// }


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
  $(target_element_id).val($(source_element_id).val());
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

function  set_new_seminar_function(url){
  var tds = $('table.calendar tbody td');
  tds.each(function(){
    var link = $("<a id='new_seminar_"+$(this).attr('id')+"' class='add_seminar_link' data-remote='true' href='"+url+'?origin='+$(this).attr('id')+"' >(+)</a>");
    $(this).prepend(link);
    insert_loaders();
  });
}

// function new_seminar(date, auth_token) {
//   $.ajax({
//     url: '/seminars/new',
//     data: 'origin='+date
//   })
//   // $('#'+element_id)
//   // Element.hide('new_seminar_'+date);
//   // Element.show('loader_new_seminar_'+date);
//   // new Ajax.Request('/seminars/new?origin='+date, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent(auth_token), onComplete:function(request){Element.hide('loader_new_seminar_'+date); Element.show('new_seminar_'+date)}});
//   // return false;
// }


function copy(text) {
  if (window.clipboardData) {
    window.clipboardData.setData("Text",text);
  }
}

function remove_field(element) {
  element.up().style.color = '#cc0000';
}

function toggleVisibilityOfFormElement(element, link_element, text) {
  $(element).toggle();
  if ($(element+':visible').length == 0) {
    $(link_element).html('► '+text);
  } else {
    $(link_element).html('▼ '+text);
  }
}
  
  
jQuery.fn.observe_field = function(frequency, callback) {

  return this.each(function(){
    var element = $(this);
    var prev = element.val();

    var chk = function() {
      var val = element.val();
      if(prev != val){
        prev = val;
        element.map(callback); // invokes the callback on the element
      }
    };
    chk();
    frequency = frequency * 1000; // translate to milliseconds
    var ti = setInterval(chk, frequency);
    // reset counter after user interaction
    element.bind('keyup', function() {
      ti && clearInterval(ti);
      ti = setInterval(chk, frequency);
    });
  });

};

function reorder(table_identifier, url) {
  var rows = $(table_identifier).find('tbody tr');
  // alert(rows.length)
  var params = [];
  rows.each(function() {
    var row_id = $(this).attr('id');
    params.push(row_id);
  });
  params = jQuery.toJSON(params)
  $.ajax({
    type: 'put', 
    data: 'ids_in_order='+params, 
    dataType: 'script',
    url: url
  })
}

function hide_abstracts(publications_div) {
  var abstracts = $(publications_div).find('p.abstract').hide();
  abstracts.each(function() {
    var link = $("<a class='show_abstract'>Show abstract</a>");
    link.insertBefore($(this));
    $(link).click(function() {
      $(this).next().slideToggle('fast');
      $(this).text(($(this).text() == 'Show abstract' ? 'Hide abstract' : 'Show abstract'));
    });
  })
}

function check_pubmed_ids() {
  $('#seminar_pubmed_ids').observe_field(1, function( ) {
    $('#publications_validation_ajax_loader').show();
    $.ajax({
      type: 'get', 
      data: 'pubmed_ids='+$(this).val(), 
      dataType: 'script',
      url: '/seminars/validate_pubmed_ids'
    })
  });
}

// function add_toggle_abstract_link() {
//   var abstracts = $('p.abstract').hide();
//   abstracts.each(function() {
//     alert($(this).text());
//     var link = $("<a class='show_abstract'>Show abstract</a>");
//     link.insertBefore($(this));
//     $(link).click(function() {
//       $(this).next().slideToggle('fast');
//       $(this).text(($(this).text() == 'Show abstract' ? 'Hide abstract' : 'Show abstract'));
//     });
//   })
// }