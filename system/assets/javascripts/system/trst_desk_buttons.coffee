define () ->
  $.extend Trst.desk.buttons,
    layout: (button) ->
      button.button
        icons:
          primary: "ui-icon-#{button.data('icon')}"
        text: false if button.data('text') is 'hidden'
      return
    handle_reload_path: (button) ->
      if button.data('reload')
        $.cookie 'reload_path', button.data('reload')
        $.cookie 'rels', button.data('rels')
        $.cookie 'tab', button.data('tab')
      return
    action:
      create: (button) ->
        $hd = Trst.desk.hdo
        $url= if button.data('url')? then button.data('url') else Trst.desk.hdf.attr('action')
        $hd.oid = if button.data('oid')? then button.data('oid') else $hd.oid
        $hd.related_id = if button.data('related_id')? then button.data('related_id') else $hd.related_id
        $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
        Trst.desk.closeDesk()
        Trst.desk.buttons.handle_reload_path(button)
        $url += "/create#{$hd.related_id}"
        Trst.desk.init($url)
        $msg('Button.create Pressed...')
      show: (button) ->
        $hd = Trst.desk.hdo
        $url= if button.data('url')? then button.data('url') else Trst.desk.hdf.attr('action')
        $hd.oid = if button.data('oid')? then button.data('oid') else $hd.oid
        if $hd.oid is null
          Trst.publish("#{$hd.dialog}.select.error",'error',$hd.model)
        else
          Trst.desk.closeDesk()
          $hd.related_id = if button.data('related_id')? then button.data('related_id') else $hd.related_id
          $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
          $url += "/#{$hd.oid}#{$hd.related_id}"
          Trst.desk.buttons.handle_reload_path(button)
          Trst.desk.init($url)
        $msg('Button.show Pressed...')
      edit: (button) ->
        $hd = Trst.desk.hdo
        $url= if button.data('url')? then button.data('url') else Trst.desk.hdf.attr('action')
        $hd.oid = if button.data('oid')? then button.data('oid') else $hd.oid
        if $hd.oid is null
          Trst.publish("#{$hd.dialog}.select.error",'error',$hd.model)
        else
          Trst.desk.buttons.handle_reload_path(button)
          Trst.desk.closeDesk()
          $hd.related_id = if button.data('related_id')? then button.data('related_id') else $hd.related_id
          $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
          $url += "/edit/#{$hd.oid}#{$hd.related_id}"
          Trst.desk.init($url)
        $msg('Button.edit Pressed...')
      save: (button) ->
        $hd   = Trst.desk.hdo
        $type = Trst.desk.hdf.attr('method')
        $data = Trst.desk.hdf.serializeArray()
        $url= if button.data('url')? then button.data('url') else Trst.desk.hdf.attr('action')
        Trst.desk.closeDesk()
        $hd.oid = if $hd.oid is null then 'create' else $hd.oid
        $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
        $url += "/#{$hd.oid}#{$hd.related_id}"
        Trst.desk.init($url,$type,$data)
        $msg('Button.save Pressed...')
      delete: (button) ->
        $hd = Trst.desk.hdo
        $url= if button.data('url')? then button.data('url') else Trst.desk.hdf.attr('action')
        $hd.oid = if button.data('oid')? then button.data('oid') else $hd.oid
        $type = Trst.desk.hdf.attr('method')
        if $hd.oid is null
          Trst.publish("#{$hd.dialog}.select.error",'error',$hd.model)
        else
          Trst.desk.buttons.handle_reload_path(button)
          Trst.desk.closeDesk()
          $hd.related_id = if button.data('related_id')? then button.data('related_id') else $hd.related_id
          $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
          if $hd.dialog is 'delete'
            $url += "/#{$hd.oid}#{$hd.related_id}"
            Trst.desk.init($url,$type)
          else
            $url += "/delete/#{$hd.oid}#{$hd.related_id}"
            Trst.desk.init($url)
        $msg('Button.delete Pressed...')
      cancel: (button) ->
        Trst.desk.closeDesk()
        if $.cookie 'reload_path'
          $url = $.cookie 'reload_path'
          $.cookie 'reload_path', null
          $.cookie 'rels', null
          Trst.desk.init($url)
        $msg('Button.cancel Pressed...')
      relations: () ->
        if $('#relationsContainer').length
          $('#relationsContainer').remove()
          return
        else
        require ['system/trst_desk_relations'], () ->
          $msg('Trst.desk.relations() Loaded...')
          Trst.desk.relations.init()
        $msg('Button.relations Pressed...')
    init: (buttons) ->
      $desk = $('#deskDialog')
      $buttons = if buttons? then buttons else $desk.find('button')
      $buttons.each () ->
        Trst.desk.buttons.layout($(this))
        $(this).click () ->
          Trst.desk.buttons.action[$(this).data('action')]($(this))
      $desk.find('.buttonset').buttonset()
      $msg('Trst.desk.buttons.init() OK...')
  return Trst
