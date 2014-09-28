define () ->
  $.extend true, Trst,
    desk:
      buttons:
        layout: (button) ->
          $bd = button.data()
          button.prepend("<i class='#{$bd.icon}'></i>")
          button.button()
          return
        handle_reload_path: (button) ->
          $hd = Trst.desk.hdo
          $bd = button.data()
          if $bd.r_mdl?
            $.ajax({type: 'POST',url: "/sys/session/r_mdl/#{$bd.r_mdl}",async: false})
            Trst.lst.setItem 'r_mdl', $bd.r_mdl
            Trst.lst.setItem 'r_id',  $bd.r_id
            Trst.lst.setItem 'tab',   $bd.tab  if $bd.tab
          if $bd.r_path?
            if $bd.r_path is 'remove'
              $.ajax({type: 'POST',url: "/sys/session/r_path/null",async: false})
              Trst.lst.removeItem 'r_path'
            else
              $.ajax({type: 'POST',url: "/sys/session/r_path/#{$bd.r_path.replace(/\//g,'!')}",async: false})
              Trst.lst.setItem 'r_path', $bd.r_path
          if $bd.url?
            [$url,$params] = $bd.url.split('?')
          else
            $url = Trst.desk.hdf.attr('action')
          if Trst.lst.r_id
            $params = if $params? then "?#{$params}&r_id=#{Trst.lst.r_id}" else "?r_id=#{Trst.lst.r_id}"
          else
            $params = if $params? then "?#{$params}" else ''
          [$url,$params]
        action:
          create: () ->
            $hd = Trst.desk.hdo
            $bd = $(@).data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path($(@))
            Trst.desk.closeDesk($bd.remove)
            $url = if $url.split('/').pop() is 'create' then "#{$url}#{$params}" else "#{$url}/create#{$params}"
            Trst.desk.init($url)
            $log('Button.create Pressed...')
          show: () ->
            $hd = Trst.desk.hdo
            $bd = $(@).data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path($(@))
            $hd.oid = if $bd.oid? then $bd.oid else $hd.oid
            if $hd.oid is null
              Trst.publish("msg.select.error",'error',$hd.model_name)
            else
              Trst.desk.closeDesk($bd.remove)
              $url += "/#{$hd.oid}#{$params}"
              Trst.desk.init($url)
            $log('Button.show Pressed...')
          edit: () ->
            $hd = Trst.desk.hdo
            $bd = $(@).data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path($(@))
            $hd.oid = if $bd.oid? then $bd.oid else $hd.oid
            if $hd.oid is null
              Trst.publish("msg.select.error",'error',$hd.model_name)
            else
              Trst.desk.closeDesk($bd.remove)
              $url = if $url.split('/').pop() is 'edit' then "#{$url}#{$params}" else "#{$url}/edit/#{$hd.oid}#{$params}"
              Trst.desk.init($url)
            $log('Button.edit Pressed...')
          save: () ->
            $hd   = Trst.desk.hdo
            $bd   = $(@).data()
            $type = Trst.desk.hdf.attr('method')
            $data = Trst.desk.hdf.serializeArray()
            [$url,$params] = Trst.desk.buttons.handle_reload_path($(@))
            Trst.desk.closeDesk($bd.remove)
            $hd.oid = if $hd.oid is null then 'create' else $hd.oid
            $url += "/#{$hd.oid}#{$params}"
            Trst.desk.init($url,$type,$data)
            $log('Button.save Pressed...')
          delete: () ->
            $hd = Trst.desk.hdo
            $bd = $(@).data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path($(@))
            $hd.oid = if $bd.oid? then $bd.oid else $hd.oid
            $type = if $bd.type? then $bd.type else Trst.desk.hdf.attr('method')
            if $hd.oid is null
              Trst.publish("msg.select.error",'error',$hd.model_name)
            else
              Trst.desk.closeDesk($bd.remove)
              if $hd.dialog is 'delete' or $bd.type is 'delete'
                $url += "/#{$hd.oid}#{$params}"
                Trst.desk.init($url,$type)
              else
                $url = if $url.split('/').pop() is 'delete' then "#{$url}#{$params}" else "#{$url}/delete/#{$hd.oid}#{$params}"
                Trst.desk.init($url)
            $log('Button.delete Pressed...')
          cancel: () ->
            $bd = $(@).data()
            Trst.desk.closeDesk($bd.remove)
            if Trst.lst.r_mdl
              $.ajax({type: 'POST',url: "/sys/session/r_mdl/null",async: false})
              Trst.lst.removeItem 'r_mdl'
              Trst.lst.removeItem 'r_id'
            if Trst.lst.r_path
              $.ajax({type: 'POST',url: "/sys/session/r_path/null",async: false})
              $url = Trst.lst.r_path
              Trst.lst.removeItem 'r_path'
              Trst.desk.init($url)
            $log('Button.cancel Pressed...')
          relations: () ->
            if $('#relationsContainer').length
              $('#relationsContainer').remove()
            else
            require ['system/trst_desk_relations'], (relations) ->
              $log('Trst.desk.relations() Loaded...')
              relations.init()
              return
            $log('Button.relations Pressed...')
          print: ()->
            $hd   = Trst.desk.hdo
            $form = Trst.desk.hdf
            Trst.msgShow Trst.i18n.msg.report.start
            $.fileDownload "#{$form.attr('action')}/print?id=#{$hd.oid}",
              successCallback: ()->
                Trst.msgHide()
                return
              failCallback: ()->
                Trst.msgHide()
                Trst.desk.createDownload $hd.model_name
                return
            $log('Button.print Pressed...')
        init: (buttons) ->
          $desk = $('#deskDialog')
          $buttons = if buttons? then buttons else $desk.find('button')
          $buttons.each () ->
            Trst.desk.buttons.layout($(@))
            $(@).on 'click', Trst.desk.buttons.action[$(@).data('action')]
            return
          $desk.find('.buttonset').buttonset()
          $log('Trst.desk.buttons.init() OK...')
  Trst.desk.buttons
