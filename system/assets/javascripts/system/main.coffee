define ['/javascripts/libs/jquery.cookie.min.js','/javascripts/libs/jquery.fileDownload.js','libs/trst_msg','system/trst_desk'], ()->
  Number::round = (n = 0)->
    Math.round(this*Math.pow(10,n))/Math.pow(10,n)
  $.extend $.fn,
    decValue: (n = 0) ->
      @each () ->
        e = $(this)
        e.change () ->
          this.value = parseFloat(this.value).round(n)
  $.extend $.fn,
    decFixed: (n = 0) ->
      @each () ->
        e = $(this)
        e.val(parseFloat(e.val()).toFixed(n))
  $.extend true,Trst,
    init: () ->
      Trst.msgHide()
      $menuItems = $('#menu.system ul li a').click ->
        $('#xhr_content').load "/sys/#{$(this).attr('id')}"
        false
      .filter('[id^="page"]').click ->
        $('#xhr_tasks').load "/sys/tasks/#{$(this).attr('id').split('_')[1]}"
        false
      $tasks = $('#sidebar.system').on 'click', 'ul li a', () ->
        $.cookie 'task_id', $(this).attr('id')
        Trst.desk.init($(this).attr('href'))
        false
      $helpers = $('#sidebar.system').on 'click', 'ul li span', () ->
        $.get "/sys/help/#{$(this).prev('a').attr('id')}", (data) ->
          $('#xhr_content').html(data)
          return
        return
      $msg('Trst.init() OK...')
  Trst
