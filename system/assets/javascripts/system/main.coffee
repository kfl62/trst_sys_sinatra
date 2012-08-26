define [
          '/javascripts/libs/jquery.cookie.min.js',
          'libs/trst_msg','system/trst_desk'
        ], () ->
  $.extend Trst,
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
  return Trst
