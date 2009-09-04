function calculate_total_price(form_id) {
  var total_price = 0;
  $$('.price').each(function(item){total_price =+ parseFloat(item.value)});
  $('order_price').value = total_price;
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

function all_day(target_id) {
  if ($('seminar_all_day').checked==true) {
    $(target_id).hide();
    set_time_to_zero(target_id);
    // able_or_disable_datetime_select(target_id, '');
    // set_datetime_blank(target_id);
  } else {
    $(target_id).show();
    // able_or_disable_datetime_select(target_id, 'on');
  }
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
  $(target_element_id).value = $(source_element_id).value
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
  var opacity = $('main').getStyle('opacity');
  if (opacity != 1.0 && $$('.ajax_div').length==1) {
    new Effect.Opacity('main', { from: opacity, to: 1.0, duration: 1.0 });
  }
  setTimeout("Element.remove(target)", 1000);
}

function get_name_from_email(source, target) {
  email = $(source).value;
  if (email.match('@') != null) {
    var name_with_dot = email.split('@')[0];
    if (name_with_dot.match('.') != null) {
      var name = name_with_dot.split('.');
      var capitalized_name = name.each(function(i) {
        i.capitalize();
      }).join(' ');
    }
    $(target).value = capitalized_name;
  }
}

function  set_new_seminar_function(auth_token){
  var tds = $$('table.calendar td.normalDay').concat($$('table.calendar td.specialDay'));
  tds.each(function(td){
    // td.setAttribute('ondblclick', "new_seminar('"+td.id+"', '"+auth_token+"' )");
    td.insert("<span style='float: right; font-size: smaller; vertical-align: top'><a id='new_seminar_"+td.id+"' href='#' onclick=\"new_seminar('"+td.id+"\', \'"+auth_token+"\' ); return false;\" >(+)</a><img id='loader_new_seminar_"+td.id+"' style='display: none;' src='/images/ajax-loader.gif' alt='Ajax-loader'/></span>");
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