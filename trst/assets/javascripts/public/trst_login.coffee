define ['jquery-ui'], ()->
  $.extend $.ui.dialog.prototype.options,
    dialogClass: 'ui-dialog-shadow'
    autoOpen: false
    modal: true
    height: 'auto'
    width: 'auto'
  module 'Trst'
  Trst.login =  (node) ->
    button = () ->
     $('#loginDialog').find('button').each () ->
        $button = $(this)
        $button.button
          icons:
            primary: $button.data('icon')
        return
      return
    $login = $('<div id="loginDialog"></div>')
    $position = $('#sidebar').position()
    $login
      .load(node.attr('href'), button)
      .dialog
        position: [$position.left, $position.top - 100]
        title: node.attr('title')
        close: (ev,ui) ->
          $(this).remove()
          return
    $login.dialog('open')
    return
  return
