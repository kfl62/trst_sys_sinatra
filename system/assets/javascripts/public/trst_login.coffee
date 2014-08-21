define ['jquery-ui'], ()->
  $.extend true,Trst,
    login: (node)->
      button = ()->
       $('#loginDialog').find('button').each ()->
          $button = $(this)
          $button.button
            icons:
              primary: $button.data('icon')
          return
        $('.cdate').val($.datepicker.formatDate('yy-mm-dd', new Date()))
        $('input').first().focus()
      $login = $('<div id="loginDialog"></div>')
      $login
        .load(node.attr('href'), button)
        .dialog
          dialogClass: 'ui-dialog-shadow'
          autoOpen: false
          modal: true
          minHeight: 10
          height: 'auto'
          width: 'auto'
          position:
            my: 'left top'
            at: 'left-50 top+20'
            of: '#login_status'
          title: node.data('title')
          close: (ev,ui)->
            $(this).remove()
            return
      $login.dialog('open')
      return
  Trst
