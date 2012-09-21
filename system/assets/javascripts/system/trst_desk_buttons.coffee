define () ->
  $.extend true, Trst,
    desk:
      buttons:
        layout: (button) ->
          $bd = button.data()
          button.button
            icons:
              primary: "ui-icon-#{$bd.icon}"
            text: false if $bd.text is 'hidden'
          return
        handle_reload_path: (button) ->
          $hd = Trst.desk.hdo
          $bd = button.data()
          if $bd.reload?
            $.post("/sys/session/rels/#{$bd.rels}") if $bd.rels
            Trst.lst.setItem 'reload_path', $bd.reload
            Trst.lst.setItem 'rels',        $bd.rels
            Trst.lst.setItem 'tab',         $bd.tab
          if $bd.url?
            [$url,$params] = $bd.url.split('?')
          else
            $url = Trst.desk.hdf.attr('action')
          $hd.related_id = if $bd.related_id? then $bd.related_id else $hd.related_id
          if $hd.related_id?
            $params = if $params? then "?#{$params}&related_id=#{$hd.related_id}" else "?related_id=#{$hd.related_id}"
          else
            $params = if $params? then "?#{$params}" else ''
          [$url,$params]
        action:
          create: (button) ->
            $hd = Trst.desk.hdo
            $bd = button.data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path(button)
            Trst.desk.closeDesk($bd.remove)
            $url = if $url.split('/').pop() is 'create' then "#{$url}#{$params}" else "#{$url}/create#{$params}"
            Trst.desk.init($url)
            $log('Button.create Pressed...')
          show: (button) ->
            $hd = Trst.desk.hdo
            $bd = button.data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path(button)
            $hd.oid = if $bd.oid? then $bd.oid else $hd.oid
            if $hd.oid is null
              Trst.publish("msg.select.error",'error',$hd.model)
            else
              Trst.desk.closeDesk($bd.remove)
              $url += "/#{$hd.oid}#{$params}"
              Trst.desk.init($url)
            $log('Button.show Pressed...')
          edit: (button) ->
            $hd = Trst.desk.hdo
            $bd = button.data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path(button)
            $hd.oid = if $bd.oid? then $bd.oid else $hd.oid
            if $hd.oid is null
              Trst.publish("msg.select.error",'error',$hd.model)
            else
              Trst.desk.closeDesk($bd.remove)
              $url = if $url.split('/').pop() is 'edit' then "#{$url}#{$params}" else "#{$url}/edit/#{$hd.oid}#{$params}"
              Trst.desk.init($url)
            $log('Button.edit Pressed...')
          save: (button) ->
            $hd   = Trst.desk.hdo
            $bd   = button.data()
            $type = Trst.desk.hdf.attr('method')
            $data = Trst.desk.hdf.serializeArray()
            [$url,$params] = Trst.desk.buttons.handle_reload_path(button)
            Trst.desk.closeDesk($bd.remove)
            $hd.oid = if $hd.oid is null then 'create' else $hd.oid
            $url += "/#{$hd.oid}#{$params}"
            Trst.desk.init($url,$type,$data)
            $log('Button.save Pressed...')
          delete: (button) ->
            $hd = Trst.desk.hdo
            $bd = button.data()
            [$url,$params] = Trst.desk.buttons.handle_reload_path(button)
            $hd.oid = if $bd.oid? then $bd.oid else $hd.oid
            $type = Trst.desk.hdf.attr('method')
            if $hd.oid is null
              Trst.publish("msg.select.error",'error',$hd.model)
            else
              Trst.desk.closeDesk($bd.remove)
              if $hd.dialog is 'delete'
                $url += "/#{$hd.oid}#{$params}"
                Trst.desk.init($url,$type)
              else
                $url = if $url.split('/').pop() is 'delete' then "#{$url}#{$params}" else "#{$url}/delete/#{$hd.oid}#{$params}"
                Trst.desk.init($url)
            $log('Button.delete Pressed...')
          cancel: (button) ->
            $bd = button.data()
            Trst.desk.closeDesk($bd.remove)
            if Trst.lst.reload_path
              $url = Trst.lst.reload_path
              Trst.lst.removeItem 'reload_path'
              Trst.lst.removeItem 'rels'
              Trst.desk.init($url)
            $log('Button.cancel Pressed...')
          relations: () ->
            if $('#relationsContainer').length
              $('#relationsContainer').remove()
              return
            else
            require ['system/trst_desk_relations'], (relations) ->
              $log('Trst.desk.relations() Loaded...')
              relations.init()
            $log('Button.relations Pressed...')
          print: (button)->
            ###
            Handled by fileDownload plugin
            http://johnculviner.com/category/jQuery-File-Download.aspx
            ###
            $log('Button.print Pressed...')
        init: (buttons) ->
          $desk = $('#deskDialog')
          $buttons = if buttons? then buttons else $desk.find('button')
          $buttons.each () ->
            Trst.desk.buttons.layout($(this))
            $(this).click () ->
              Trst.desk.buttons.action[$(this).data('action')]($(this))
          $desk.find('.buttonset').buttonset()
          $log('Trst.desk.buttons.init() OK...')
  Trst
