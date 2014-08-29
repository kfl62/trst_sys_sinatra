define ['jquery-ui','system/trst_desk_buttons','system/trst_desk_select','system/trst_desk_tabs'], ()->
  do ($ = jQuery, window, document) ->
    $.widget "app.dialog", $.ui.dialog,
      options:
        iconButtons: []
      _create: ->
        @_super()
        $titlebar = @uiDialog.find(".ui-dialog-titlebar")
        $.each @options.iconButtons, (i, v) ->
          $button = $("<button/>").text(@text)
          right = $titlebar.find("[role='button']:last").css("right")
          $button.button(
            icons:
              primary: @icon
            text: false
          ).addClass("ui-dialog-titlebar-close").css("right", (parseInt(right) + 22) + "px").click(@click).appendTo $titlebar
          return
        return
  $.extend true, Trst,
    desk:
      readData: ()->
        @hdo = if $('#hidden_data').length then $('#hidden_data').data() else {}
        @hdf = $('#deskDialog form')
        @height = $(window).height()
        if (!$.isEmptyObject(@hdo) and @hdf?) then true else false
      closeDesk: (cls = true)->
        if cls
          $('#deskDialog').dialog('close')
          $('[class^="select2"]').remove()
          $('[class^="ui-datepicker"]').remove()
        return
      createDesk: (data)->
        $desk = if $('#deskDialog').length then $('#deskDialog') else $('<div id="deskDialog"></div>')
        $desk.html(data)
        .dialog
          dialogClass: 'ui-dialog-trst'
          autoOpen: false
          resizable: false
          modal: true
          minHeight: 10
          height: 'auto'
          width: 'auto'
          position:
            my: 'left top'
            at: 'left top'
            of: 'nav'
            collision: 'none'
          close: ()->
            $(@).remove()
            return
          iconButtons: [
            {
              text: "Help"
              icon: "ui-icon-info"
              click: (e) ->
                alert 'Not ready! :)'
                return
            }
          ]
        return
      downloadError: (data)->
        $download = if $('#downloadDialog').length then $('#downloadDialog') else $('<div id="downloadDialog" class="small"></div>')
        $data = Trst.i18n.msg.report.error. replace '%{data}', data
        $download.html($data)
        .dialog
          dialogClass: 'ui-dialog-trst'
          autoOpen: false
          modal: true
          height: 'auto'
          width: 'auto'
          position:
            my: 'left top'
            at: 'left top'
            of: '#menu'
            collision: 'none'
          close: ()->
            $(@).remove()
            return
          title: Trst.i18n.title.report.error
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
          Trst.publish('msg.desk.error', 'error', "#{xhr.status} #{xhr.statusText}")
          false
        $request.done (data)->
          if $type isnt 'GET' then Trst.publish('flash')
          if $type isnt 'DELETE'
            Trst.desk.createDesk(data)
            if Trst.desk.readData()
              $desk  = $('#deskDialog')
              $title = Trst.i18n.title[Trst.desk.hdo.dialog][Trst.desk.hdo.js_ext] || Trst.i18n.title[Trst.desk.hdo.dialog]['main']
              $tdata = Trst.desk.hdo.title_data || Trst.desk.hdo.model_name
              $desk.dialog title: $("<span>#{$title.replace('%{data}',$tdata)}</span>").text()
              $desk.dialog('open')
              Trst.desk.buttons.init() if $('button').length
              Trst.desk.select.init() if Trst.desk.hdf.find('select').length
              Trst.desk.tabs.init() if $('tbody[id^="tabs-"]').length
              Trst.module.desk.init() if Trst.module?
              return
            else
              alert Trst.i18n.msg.session.relogin
              Trst.lst.clear()
              window.location = '/'
              $log 'Initialize error...'
          else
            if Trst.lst.r_path
              $url = Trst.lst.r_path
              Trst.lst.removeItem 'r_path'
              Trst.lst.removeItem 'r_mdl'
              Trst.lst.removeItem 'r_id'
              Trst.desk.init($url)
              return
        $log('Trst.desk.init() ...')
  Trst.desk
