define ['jquery-ui','system/trst_desk_buttons','system/trst_desk_select','system/trst_desk_tabs'], ()->
  $.extend true, Trst,
    desk:
      readData: ()->
        @hdo = if $('#hidden_data').length then $('#hidden_data').data() else {}
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
              $desk  = $('#deskDialog')
              $title = Trst.i18n.title[Trst.desk.hdo.dialog][Trst.desk.hdo.js_ext] || Trst.i18n.title[Trst.desk.hdo.dialog]['main']
              $desk.dialog title: $title.replace('%{data}',Trst.desk.hdo.model_name)
              $desk.dialog('open')
              Trst.desk.buttons.init() if $('button').length
              Trst.desk.select.init() if Trst.desk.hdf.find('select').length
              Trst.desk.tabs.init() if $('tbody[id^="tabs-"]').length
              Trst.module.desk.init() if Trst.module?
              return
            else
              $log 'Initialize error...'
          else
            if Trst.lst.reload_path
              $url = Trst.lst.reload_path
              Trst.lst.removeItem 'reload_path'
              Trst.lst.removeItem 'rels'
              Trst.desk.init($url)
              return
        $log('Trst.desk.init() ...')
  Trst.desk
