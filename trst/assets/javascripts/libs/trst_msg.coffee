define ()->
  module 'Trst'
  sysMsg = $.subscribe 'xhrMsg', (event,what,kind,data) ->
    $xhr_msg = $('#xhr_msg')
    $.ajax
      url: "/utils/msg"
      type: 'POST'
      data: {what: what, kind: kind, data: data}
      dataType: 'json'
    .done (data) ->
      $xhr_msg.html(data.msg.txt)
        .stop(true,true)
        .addClass(data.msg.class)
        .fadeIn(0)
        .delay(2000)
        .fadeOut(1000,'linear',() -> $(this).removeAttr('class');return)
      return
    return
  Trst.publish = (args...) ->
    $.publish 'xhrMsg', args
    return
  Trst.msgShow = (msg = '...') ->
      $('#xhr_msg').stop(true,true).fadeOut(0,'linear',() -> $(this).removeAttr('class');return)
      .html(msg).addClass('loading').fadeIn()
      return
  Trst.msgHide = () ->
      $('#xhr_msg').stop(true,true).fadeOut(1000,'linear',() -> $(this).removeAttr('class');return)
      return
  return Trst
