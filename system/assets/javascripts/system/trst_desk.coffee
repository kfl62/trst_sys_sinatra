define ['system/trst_desk_buttons','system/trst_desk_selects','system/trst_desk_inputs','system/trst_desk_tables'], ()->
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

  $.extend true, $.fn.select2.defaults,
    formatInputTooShort: (input, min)->
      Trst.desk.inputs.__f.inputTooShortMsg(input, min)
    formatSearching: ()->
      Trst.i18n.msg.searching
    formatNoMatches: (term)->
     Trst.i18n.msg.no_matches

  $.extend true, Trst,
    desk:
      readData: ()->
        @hdo = if $('#hidden_data').length then $('#hidden_data').data() else {}
        @hdf = $('#deskDialog form')
        @height = $(window).height()
        if (!$.isEmptyObject(@hdo) and @hdf?) then true else false
      handleRequires: ()->
        @buttons.init() if $('button').length
        @selects.init() if $('select').length
        @inputs.init()  if $('input').length
        @tables.init()  if $('table').length
        Trst.module.desk.init()  if Trst.module?
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
              icon: "ui-icon-info"
              click: (e) ->
                $('#xhr_info').toggle()
                return
            }
          ]
        return
      closeDesk: (cls = true)->
        if cls
          $('#deskDialog').dialog('close')
          $('[class^="select2"]').remove()
          $('[class^="ui-datepicker"]').remove()
        return
      createDownload: (data)->
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
          beforeSend: ()-> $('#xhr_msg').html("<span>...</span>").addClass('loading').prepend("<i class='fa fa-refresh fa-spin fa-lg'></i>").show()
          complete:   ()-> $('#xhr_msg').hide().removeAttr('class').html('')
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
              Trst.desk.handleRequires()
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
