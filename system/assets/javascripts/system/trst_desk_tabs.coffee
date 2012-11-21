define () ->
  $.extend true,Trst,
    desk:
      tabs:
        init: () ->
          $tabsDefs = $('<div id="tabsDefs"><ul></ul></div>')
          $('tbody[id^="tabs-"]').each () ->
            $tab = $(this)
            $href = if $tab.data('href') then $tab.data('href') else "##{$tab.attr('id')}"
            $tabsDefs.find('ul').append("<li><a href='#{$href}'>#{$tab.data('title')}</a></li>")
            $(this).appendTo($tabsDefs)
          $('#deskDialog thead').after($tabsDefs)
          $tabsDefs.tabs
            panelTemplate: '<tbody></tbody>'
            selected: if Trst.lst.tab then Trst.lst.tab else 0
            show: (event,ui) ->
              $('input.focus').focus()
              Trst.lst.removeItem 'tab'
              return
          $log('Trst.desk.tabs.init() OK...')
  Trst
