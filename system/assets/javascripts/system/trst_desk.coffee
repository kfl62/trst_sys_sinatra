define ['jquery-ui','system/trst_desk_buttons','system/trst_desk_select','system/trst_desk_tabs'], ()->
  $.extend true, Trst,
    desk:
      readData: ()->
        @hda = $('#hidden_data')
        @hdo = if @hda.length then @hda.data() else {}
        @hdf = $('#deskDialog form')
        if (!$.isEmptyObject(@hdo) and @hdf?) then true else false
      closeDesk: (cls = true)->
        $('#deskDialog').dialog('close') if cls
        return
      createDesk: (data)->
        $desk = if $('#deskDialog').length then $('#deskDialog') else $('<div id="deskDialog"></div>')
        $position = $('#content').position()
        if $desk.dialog('isOpen') is true
          $desk.html(data)
        else
          $desk.html(data)
          .dialog
            dialogClass: 'ui-dialog-shadow'
            autoOpen: false
            modal: true
            height: 'auto'
            width: 'auto'
            position: [$position.left + 10,$position.top - 20]
            close: ()->
              $(this).remove()
              return
        return
      downloadError: (data)->
        $download = if $('#downloadDialog').length then $('#downloadDialog') else $('<div id="downloadDialog" class="small"></div>')
        $position = $('#content').position()
        $download.dialog
          dialogClass: 'ui-dialog-shadow'
          autoOpen: false
          modal: true
          height: 'auto'
          width: 'auto'
          position: [$position.left + 10,$position.top - 30]
          close: ()->
            $(this).remove()
            return
          title: 'Hmmm ceva nu-a mers bine...!'
        $.post(
          '/utils/msg'
          data
          (response)-> $download.html(response.msg.txt)
          'json'
        )
        $download.dialog('open')
      init: (url,type,data)->
        $url  = url
        $type = if type? then type.toUpperCase() else "GET"
        $data = if data? then data else []
        $request = $.ajax
          url : $url
          type: $type
          data: $data
          beforeSend: ()-> Trst.msgShow()
          complete:   ()-> Trst.msgHide()
        $request.fail (xhr)->
          Trst.publish('error.desk', 'error', "#{xhr.status} #{xhr.statusText}")
          false
        $request.done (data)->
          if $type isnt 'GET' then Trst.publish('flash')
          if $type isnt 'DELETE'
            Trst.desk.createDesk(data)
            if Trst.desk.readData()
              $desk = $('#deskDialog')
              $desk.dialog title: Trst.desk.hdo.title
              $desk.dialog('open')
              Trst.desk.buttons.init() if $('button').length
              Trst.desk.select.init() if Trst.desk.hdf.find('select').length
              Trst.desk.tabs.init() if $('tbody[id^="tabs-"]').length
              Trst.module.desk.init() if Trst.module?
              return
            else
              $msg 'Initialize error...'
          else
            if $.cookie 'reload_path'
              $url = $.cookie 'reload_path'
              $.cookie 'reload_path', null
              $.cookie 'rels', null
              Trst.desk.init($url)
              return
        $msg('Trst.desk.init() ...')
  Trst
