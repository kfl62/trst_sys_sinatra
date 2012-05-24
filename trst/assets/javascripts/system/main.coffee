define ['libs/trst_msg','system/trst_desk'], () ->
  $.extend Trst,
    debug: true
    init: () ->
      Trst.msgHide()
      $menuItems = $('#menu.system ul li a').click ->
        $('#xhr_content').load "/sys/#{$(this).attr('id')}"
        false
      .filter('[id^="page"]').click ->
        $('#xhr_tasks').load "/sys/tasks/#{$(this).attr('id').split('_')[1]}"
        false
      $tasks = $('#sidebar.system').on 'click', 'ul li a', (event) ->
        Trst.desk.init($(this).attr('href'))
        false
      $msg('Trst.init() OK...')
  return Trst
