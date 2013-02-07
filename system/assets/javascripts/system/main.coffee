define ['/javascripts/libs/jquery.fileDownload.js','libs/trst_msg','system/trst_desk'], ()->
  Storage::setObject = (key,value)->
    @setItem key, JSON.stringify(value)
  Storage::getObject = (key)->
    value = @getItem(key)
    value && JSON.parse(value)
  Number::round = (n = 0)->
    Math.round(@*Math.pow(10,n))/Math.pow(10,n)
  $.extend $.fn,
    decValue: (n = 0) ->
      @each () ->
        e = $(@)
        e.change () ->
          @value = parseFloat(@value).round(n)
  $.extend $.fn,
    decFixed: (n = 0) ->
      @each () ->
        e = $(@)
        e.val(parseFloat(e.val()).toFixed(n))
  $.extend true,Trst,
    lst:  sessionStorage
    i18n: sessionStorage.getObject('i18n')
    init: () ->
      Trst.msgHide()
      unless Trst.lst.i18n?
        $.post('/utils/msg', (data)->
            Trst.lst.setObject 'i18n', data.msg.txt
            Trst.i18n = Trst.lst.getObject('i18n')
            delete Trst.i18n.sidebar
            delete Trst.i18n.login
            return
          'json')
      $menuItems = $('#menu.system ul li a').click ()->
        $('#xhr_content').load "/sys/#{$(@).attr('id')}"
        false
      .filter('[id^="page"]').click ()->
        $('#xhr_content').load "/sys/#{$(@).attr('id')}"
        $('#xhr_tasks').load "/sys/tasks/#{$(@).attr('id').split('_')[1]}"
        false
      $tasks = $('#sidebar.system').on 'click', 'ul li a', ()->
        $url = $(@).attr('href')
        Trst.lst.setItem 'task_id', $(@).attr('id')
        $.ajax({type: 'POST',url: "/sys/session/task_id/#{$(@).attr('id')}",async: false})
        Trst.desk.init($url)
        false
      $helpers = $('#sidebar.system').on 'click', 'ul li span', ()->
        $.get "/sys/help/#{$(@).prev('a').attr('id')}", (data)->
          $('#xhr_content').html(data)
          return
        return
      $helpClose = $('#content').on 'click', '#xhr_content p.close', ()->
        $('#xhr_content').load "/sys/page_#{Trst.lst.page_id}"
        return
      $(window).unload ()->
        $.ajax({url: "/utils/logout",async: false})
      $log('Trst.init() OK...')
  Trst
