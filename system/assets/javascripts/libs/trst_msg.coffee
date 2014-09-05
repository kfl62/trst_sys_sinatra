define ()->
  sysMsg = $.subscribe 'xhrMsg', (event,what,kind,data)->
    $xhr_msg = $('#xhr_msg')
    $msg = eval("Trst.i18n.#{what}")
    if typeof $msg is 'string'
      $msg = $msg.replace '%{data}', data
      $icon = switch
        when kind is 'info' then 'fa fa-info-circle fa-lg blue'
        when kind is 'warning' then 'fa fa-exclamation-triangle fa-lg'
        when kind is 'error' then 'fa fa-bomb fa-lg'
        else 'fa fa-refresh fa-spin fa-lg'
      if kind is 'error' then d = 5000 else d = 2000
      $xhr_msg.html("<span>#{$msg}</span>")
        .stop(true,true)
        .addClass(kind)
        .prepend("<i class='#{$icon}'></i>")
        .fadeIn(0)
        .delay(d)
        .fadeOut(1000,'linear',()-> $(this).removeAttr('class'); return)
    else
      $.ajax
        url: "/utils/msg"
        type: 'POST'
        data: {what: what, kind: kind, data: data}
        dataType: 'json'
      .done (data)->
        if data.msg.cls is 'error' then d = 5000 else d = 2000
        $icon = switch
          when data.msg.cls is 'info' then 'fa fa-info-circle fa-lg blue'
          when data.msg.cls is 'warning' then 'fa fa-exclamation-triangle fa-lg'
          when data.msg.cls is 'error' then 'fa fa-bomb fa-lg'
          else 'fa fa-refresh fa-spin fa-lg'
        $xhr_msg.html("<span>#{data.msg.txt}</span>")
          .stop(true,true)
          .addClass(data.msg.cls)
          .prepend("<i class='#{$icon}'></i>")
          .fadeIn(0)
          .delay(d)
          .fadeOut(1000,'linear',()-> $(this).removeAttr('class'); return)
        return
    return
  $.extend Trst,
    publish: (args...)->
      $.publish 'xhrMsg', args
      return
    msgShow: (msg = '<span>...</span>', cls = 'loading') ->
        $icon = switch
          when cls is 'info' then 'fa fa-info-circle fa-lg blue'
          when cls is 'warning' then 'fa fa-exclamation-triangle fa-lg'
          when cls is 'error' then 'fa fa-bomb fa-lg'
          else 'fa fa-refresh fa-spin fa-lg'
        $('#xhr_msg').stop(true,true).fadeOut(0,'linear',()-> $(this).removeAttr('class');return)
        .html(msg).prepend("<i class='#{$icon}'></i>").addClass(cls).fadeIn()
        return
    msgHide: () ->
        if $('#xhr_msg').hasClass('error') then d = 5000 else d = 0
        $('#xhr_msg').stop(true,true).delay(d).fadeOut(500,'linear',()-> $(this).removeAttr('class');return)
        return
  Trst
