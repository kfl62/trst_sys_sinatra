define ()->
  sysMsg = $.subscribe 'xhrMsg', (event,what,kind,data)->
    $xhr_msg = $('#xhr_msg')
    $msg = eval("Trst.i18n.#{what}")
    if typeof $msg is 'string'
      $msg = $msg.replace '%{data}', data
      if kind is 'error' then d = 5000 else d = 2000
      $xhr_msg.html($msg)
        .stop(true,true)
        .addClass(kind)
        .fadeIn(0)
        .delay(d)
        .fadeOut(1000,'linear',()-> $(this).removeAttr('class');return)
    else
      $.ajax
        url: "/utils/msg"
        type: 'POST'
        data: {what: what, kind: kind, data: data}
        dataType: 'json'
      .done (data)->
        if data.msg.class is 'error' then d = 5000 else d = 2000
        $xhr_msg.html(data.msg.txt)
          .stop(true,true)
          .addClass(data.msg.class)
          .fadeIn(0)
          .delay(d)
          .fadeOut(1000,'linear',()-> $(this).removeAttr('class');return)
        return
    return
  $.extend Trst,
    publish: (args...)->
      $.publish 'xhrMsg', args
      return
    msgShow: (msg = '...')->
        $('#xhr_msg').stop(true,true).fadeOut(0,'linear',()-> $(this).removeAttr('class');return)
        .html(msg).addClass('loading').fadeIn()
        return
    msgHide: () ->
        if $('#xhr_msg').hasClass('error') then d = 5000 else d = 0
        $('#xhr_msg').stop(true,true).delay(d).fadeOut(500,'linear',()-> $(this).removeAttr('class');return)
        return
  Trst
