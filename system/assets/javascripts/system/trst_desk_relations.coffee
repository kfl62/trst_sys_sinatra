define () ->
  $.extend true,Trst,
    desk:
      relations:
        makeSelectable: ()->
          $('#deskDialog ul.trst-ui-sortable, #relationsContainer ul.trst-ui-sortable')
            .sortable
              connectWith: '.trst-ui-sortable'
              placeholder: 'ui-state-highlight'
              appendTo:    'body'
              helper:      'clone'
              zIndex:      1010
              start: (event,ui) ->
                ui.placeholder.height(ui.helper.height)
                return
            .disableSelection()
          return
        createContainer: ()->
          $button    = $('#deskDialog form button[data-action="relations"]')
          $container = $('<div id="relationsContainer"></div>')
          $container.css
            top:    $button.offset().top
            left:   $button.offset().left + $button.width() + 15
            zIndex: 1005
          $container
        init: ()->
          $hd      = Trst.desk.hdo
          $form    = Trst.desk.hdf
          $button  = $('#deskDialog form button[data-action="relations"]')
          $url     = "#{$form.attr('action').replace(/sys/,'utils/relations')}/#{$hd.oid}/#{$button.data('rel_to')}"
          $request = $.ajax url: $url, type: 'GET'
          $request.fail (xhr) ->
            Trst.publish('error.desk', 'error', "#{xhr.status} #{xhr.statusText}")
          $request.done (data) ->
            $container = Trst.desk.relations.createContainer()
            $container.append(data).appendTo('#deskDialog')
            Trst.desk.relations.makeSelectable()
          $log('Trst.desk.relations.init() OK...')
  Trst.desk.relations
