dojo.mixin(trst.task.acc,{
  grn_transfer: {
    init: function(){
      // Connect button 'Post' on filter
      if (trst.task.acc.hd.action == 'filter'){
        var bpo = dojo.query('.button.post.mc-evt')
        bpo.onclick(function(){
          var path =  trst.task.acc.grn_transfer.initSelectDeliveryNote()
          trst.task.init(trst.task.acc.hd.task_id,'query',path)
        })
      }
      // Connect trigger,toggle,post on select delivery note
      if (trst.task.acc.hd.action == 'query'){
        var trgr = dojo.query('input.trigger'),
            tggl = dojo.query('span.trigger'),
            post = dojo.query('.button.post.mc-evt');
        trgr.onchange(function(){
          trst.task.acc.grn_transfer.onDeliveryNoteSelect()
        })
        tggl.onclick(function(e){
          trst.task.acc.grn_transfer.onDeliveryNoteToggle(e.target)
        })
        post.onclick(function(){
          trst.task.acc.grn_transfer.onDeliveryNoteSelectedPost()
        })
      }
      // Connect buttons ('Save','Cancel','Delete', etc.) except 'Post'
      this.connectButtons()
    },
    initSelectDeliveryNote: function(){
      var tax  = dojo.query("[name='out_003']")[0],
          path = 'new';
      path += '?to_unit' + trst.task.acc.hd.to_unit
      path += '&out_003=' + tax.checked
      return path
    },
    selectedDeliveryNotes: function(){
      var dns = []
      dojo.query('input.trigger:checked').forEach(
        function(node){
          dns.push(node.id)
        }
      )
      return dns
    },
    onDeliveryNoteSelect: function(){
      var path = 'new'
      path += '?out_003=' + trst.task.acc.hd.out_003
      path += '&dn_ary=' + this.selectedDeliveryNotes()
      trst.task.init(trst.task.acc.hd.task_id,'query', path);
    },
    onDeliveryNoteToggle: function(node){
      var toggle_state = !node.previousElementSibling.checked
      node.previousElementSibling.checked = toggle_state
      this.onDeliveryNoteSelect()
    },
    onDeliveryNoteSelectedPost: function(){
      var path = 'new'
      path += '?supplier_id=' + trst.task.acc.hd.supplier_id
      path += '&to_unit=' + trst.task.acc.hd.to_unit
      path += '&dns=' + this.selectedDeliveryNotes()
      trst.task.init(trst.task.acc.hd.task_id,'post',path)
    },
    connectButtons: function(){
      var bs = dojo.query('.button.save.mc-evt'),
          bp = dojo.query('.button.print.mc-evt'),
          bc = dojo.query('.button.cancel.mc-evt'),
          bd = dojo.query('.button.delete.mc-evt');
      if (bs.length > 0){
        bs.onclick(function(){
          if (selectedValue(dojo.query('select')[0]) != 'null'){
            trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
          }else{
            alert('Nu aţi selectat delegatul!')
          }
        })
      }
      if (bp.length > 0){
        bp.onclick(function(){
          trst.task.acc.print(trst.task.acc.hd.task_id,'print',trst.task.acc.hd.object_id)
        })
      }
      if (bc.length > 0){
        bc.onclick(function(){
          trst.task.destroy()
        })
      }
      if (bd.length > 0){
        bd.onclick(function(){
          trst.task.init(trst.task.acc.hd.task_id,'delete',trst.task.acc.hd.object_id)
        })
      }
    }
  }
})

