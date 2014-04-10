$(function() {
  show_hide_beta_notif();
})

function show_hide_beta_notif() {
  var
    beta_notif = $('#beta_notification'),
    height = beta_notif.outerHeight(),
    cookie = $.cookie('beta_notif'),
    link = $("<a id='beta_notif_link'></a>");
  beta_notif.append(link);
  if (cookie=='dismissed') {
    beta_notif.css('width', "100px").css('margin-left', "-20px").addClass('dismissed');
    var height = beta_notif.outerHeight();
    beta_notif.css('top', "-"+(height-10)+"px");
    link.html('Warning');
  } else {
    beta_notif.removeClass('dismissed');
    beta_notif.css('width', "400px").css('margin-left', "-200px").css('top', "15px").removeClass('dismissed');
    link.html('Hide');
  }


  link.on('click', function() {
    if (beta_notif.hasClass('dismissed')) {
      beta_notif.css('width', "400px").css('margin-left', "-200px").css('top', "15px").removeClass('dismissed');
      $.cookie('beta_notif', 'showing', {path: '/', expires: 365});
      $(this).text('Hide');
    } else {
      beta_notif.css('width', "100px").css('margin-left', "-20px").addClass('dismissed');
      var height = beta_notif.outerHeight();
      beta_notif.css('top', "-"+(height-30)+"px");
      $.cookie('beta_notif', 'dismissed', {path: '/', expires: 365});
      $(this).text('Warning');
    }
  })
}
