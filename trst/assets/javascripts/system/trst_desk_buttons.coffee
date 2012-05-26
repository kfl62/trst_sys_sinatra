define () ->
  $.extend Trst.desk.buttons,
    layout: (button) ->
      button.button
        icons:
          primary: "ui-icon-#{button.data('icon')}"
      return
    action:
      show: () ->
        $hd = Trst.desk.hdo
        $url= Trst.desk.hdf.attr('action')
        if $hd.oid is null
          Trst.publish("#{$hd.dialog}.select.error",'error',$hd.model)
        else
          Trst.desk.closeDesk()
          $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
          $url += "/#{$hd.oid}#{$hd.related_id}"
          Trst.desk.init($url)
        $msg('Button.show Pressed...')
      edit: () ->
        $hd = Trst.desk.hdo
        $url= Trst.desk.hdf.attr('action')
        if $hd.oid is null
          Trst.publish("#{$hd.dialog}.select.error",'error',$hd.model)
        else
          Trst.desk.closeDesk()
          $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
          $url += "/edit/#{$hd.oid}#{$hd.related_id}"
          Trst.desk.init($url)
        $msg('Button.edit Pressed...')
      save: () ->
        $hd   = Trst.desk.hdo
        $url  = Trst.desk.hdf.attr('action')
        $type = Trst.desk.hdf.attr('method')
        $data = Trst.desk.hdf.serializeArray()
        Trst.desk.closeDesk()
        $hd.oid = if $hd.oid is null then 'create' else $hd.oid
        $hd.related_id = if $hd.related_id is null then '' else "?related_id=#{$hd.related_id}"
        $url += "/#{$hd.oid}#{$hd.related_id}"
        Trst.desk.init($url,$type,$data)
        $msg('Button.save Pressed...')
      delete: () ->
        $hd = Trst.desk.hdo
        if $hd.oid is null
          Trst.publish("#{$hd.dialog}.select.error",'error',$hd.model)
        else
          return false
        $msg('Button.delete Pressed...')
      cancel: () ->
        Trst.desk.closeDesk()
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
          Trst.desk.buttons.action[$(this).data('action')]()
      $desk.find('.buttonset').buttonset()
      $msg('Trst.desk.buttons.init() OK...')
  return Trst
