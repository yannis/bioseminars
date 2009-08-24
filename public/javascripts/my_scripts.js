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
  var datetime_array = ['4i', '5i'];
  if ($('seminar_all_day').checked==true) {
    datetime_array.each( function(item) {
      $(target_id+'_'+item).hide();
    }
  )
    set_time_to_zero(target_id);
    // able_or_disable_datetime_select(target_id, '');
    // set_datetime_blank(target_id);
  } else {
      datetime_array.each( function(item) {
        $(target_id+'_'+item).show();
      }
    )
    // able_or_disable_datetime_select(target_id, 'on');
  }
}

function able_or_disable_datetime_select(target_id, value) {
  selects = $$('#'+target_id+' select');
  selects.each(function(item) {
    if (value == '') {item.disable()} else {item.enable()};
  })
}