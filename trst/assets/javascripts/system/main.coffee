define ['libs/trst_msg'], () ->
  module 'Trst'
  Trst.init = () ->
    Trst.msgHide()
    $menuItems = $('#menu.system ul li a').click ->
      $('#xhr_content').load "/sys/#{$(this).attr('id')}"
      false
    .filter('[id^="page"]').click ->
      $('#xhr_tasks').load "/sys/tasks/#{$(this).attr('id').split('_')[1]}"
      false
    $tasks = $('#sidebar.system').on 'click', 'ul li a', (event) ->
      trst.desk($(this).attr('href'))
      false
    return
  return Trst
