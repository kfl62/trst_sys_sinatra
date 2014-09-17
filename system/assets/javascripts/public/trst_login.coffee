define ['jquery-ui'], ()->
  $.extend true,Trst,
    login: (node)->
      init = ()->
        $('.cdate').val($.datepicker.formatDate('yy-mm-dd', new Date()))
        $('input').first().focus()
      $login = $('<div id="loginDialog"></div>')
      $login
        .load(node.attr('href'), init)
        .dialog
          autoOpen: false
          modal: true
          minHeight: 10
          height: 'auto'
          width: 240
          resizable: false
          position:
            my: 'right top'
            at: 'right top+20'
            of: 'body'
          title: node.data('title')
          close: (ev,ui)->
            $(this).remove()
            return
      $login.dialog('open')
      return
  Trst
