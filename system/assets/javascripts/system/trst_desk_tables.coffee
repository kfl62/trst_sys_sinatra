define () ->
  $.extend true,Trst,
    desk:
      tables:
        handleScroll: (tbl,h=450)->
          $table = $(tbl)
          if h isnt 0
            tblHdr   = $("<table style='width:auto'><tbody class='inner'><tr></tr><tr></tr></tbody></table>")
            tblCntnr = $("<div id='scroll-container' style='height:#{h}px;overflow-x:hidden;overflow-y:scroll'></div>")
            tblClmnW = []
            $table.find('tr[data-mark~=scroll] td').each (i)->
              tblClmnW[i] = $(@).width()
              return
            tblscrll = $table.find('tr[data-mark~=scroll]').html()
            $table.find('tr[data-mark~=scroll]').html('')
            $table.css('width','auto')
            tblHdr.find('tr:first').html(tblscrll)
            tblHdr.find('tr:first td').each (i)->
              $(@).css('width', tblClmnW[i])
            $table.find('tr[data-mark~=scroll]').next().find('td').each (i)->
              $(@).css('width', tblClmnW[i])
              return
            $table.before(tblHdr)
            $table.wrap(tblCntnr)
          else
            tblscrll = $('div#scroll-container').prev().find('tr:first').html()
            $('div#scroll-container').prev().remove()
            $table.find('tr[data-mark~=scroll]').html(tblscrll)
            $table.unwrap()
          return
        handleTab: ()->
          $tabsDefs = $('<div id="tabsDefs"><ul></ul></div>')
          $('tbody[id^="tabs-"]').each () ->
            $tab = $(this)
            $href = if $tab.data('href') then $tab.data('href') else "##{$tab.attr('id')}"
            $tabsDefs.find('ul').append("<li><a href='#{$href}'>#{$tab.data('title')}</a></li>")
            $(this).appendTo($tabsDefs)
          $('#deskDialog thead').after($tabsDefs)
          $tabsDefs.tabs
            panelTemplate: '<tbody></tbody>'
            active: if Trst.lst.tab then Trst.lst.tab else 0
            create: (event,ui) ->
              $('input.focus').focus()
              Trst.lst.removeItem 'tab'
              return
          return
        init: ()->
          @handleScroll($('table[data-mark~=scroll]')) if $('table[data-mark~=scroll]').height() > 450
          @handleTab() if $('tbody[id^="tabs-"]').length
          $log('Trst.desk.tables.init() OK...')
  Trst.desk.tables
