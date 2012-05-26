define ['jquery-ui','system/trst_desk_buttons','system/trst_desk_select'], () ->
  $.extend Trst.desk,
    readData: () ->
      @hda = $('#hidden_data')
      @hdo = if @hda.length then @hda.data() else {}
      @hdf = $('#deskDialog form')
      if (!$.isEmptyObject(@hdo) and @hdf?) then true else false
    close: () ->
      $('#deskDialog').dialog('close')
      $.cookie('task_id',null)
      return
    createDialog: (data) ->
      $desk = $('<div id="deskDialog"></div>')
      $position = $('#content').position()
      $desk.html(data)
      .dialog
        dialogClass: 'ui-dialog-shadow'
        autoOpen: false
        modal: true
        height: 'auto'
        width: 'auto'
        position: [$position.left + 10,$position.top - 20]
        close: () ->
          $(this).remove()
          return
      return
    init: (url,type,data) ->
      $url  = url
      $type = if type? then type.toUpperCase() else "GET"
      $data = if data? then data else []
      $request = $.ajax
        url : $url
        type: $type
        data: $data
        beforeSend: () -> Trst.msgShow()
        complete:   () -> Trst.msgHide()
      $request.fail (xhr) ->
        Trst.publish('error.desk', 'error', "#{xhr.status} #{xhr.statusText}")
        false
      $request.done (data) ->
        if $type isnt 'GET' then Trst.publish('flash')
        if $type isnt 'DELETE'
          Trst.desk.createDialog(data)
          if Trst.desk.readData()
            $desk = $('#deskDialog')
            $desk.dialog title: Trst.desk.hdo.title
            Trst.desk.buttons.init()
            Trst.desk.select.init() if Trst.desk.hdf.find('select').length
            $desk.dialog('open')
            return
          else
            console.log 'Initialize error...'
      $msg('Trst.desk.init() ...')
  return Trst
