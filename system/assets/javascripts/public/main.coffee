define ['libs/trst_msg','public/trst_login','public/trst_map'], ()->
  $.extend Trst,
    init: ()->
      Trst.msgHide()
      $('a.header-login').click ()->
        Trst.login($(this))
        false
      $menuItems = $('nav.menu ul li a').click ()->
        $('#xhr_content').load "/#{$(this).attr('id')}"
        false
      Trst.gmap($('#google_map')[0])
      $(document).tooltip
        content: ()->
          $(@).attr('title').replace(/\n/g, "<br/>")
      return
  Trst
