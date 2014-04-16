# $scrollfollow   = $(".scrollfollow")
# $window    = $(window)
# offset     = $scrollfollow.offset()
# topPadding = 15

# $window.scroll ->
#   if $window.scrollTop() > offset.top
#     $scrollfollow.stop().animate
#       marginTop: $window.scrollTop() - offset.top + topPadding
#   else
#     $scrollfollow.stop().animate
#       marginTop: 0
