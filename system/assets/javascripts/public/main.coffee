define ['libs/trst_msg','public/trst_login','public/trst_map'], ()->
  $.extend Trst,
    init: () ->
      Trst.msgHide()
      $('#login_status[href$="login"]').click ->
        Trst.login($(this))
        false
      $menuItems = $('#menu.public ul li a').click ->
        $('#xhr_content').load "/#{$(this).attr('id')}"
        false
      Trst.gmap($('#google_map')[0])
      return
  return Trst
