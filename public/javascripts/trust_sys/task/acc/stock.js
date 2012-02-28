dojo.mixin(trst.task.acc,{
  stock: {
    init: function(){
      // Connect select, 'Post' on filter
      if (trst.task.acc.hd.action == 'filter'){
        dojo.query('select').onchange(function(evt){
          if (selectedValue(evt.target) != 'null'){
            trst.task.init(trst.task.acc.hd.task_id,'get',selectedValue(evt.target))
          }
        })
        dojo.query('.button.post.mc-evt').onclick(function(){
           trst.task.init(trst.task.acc.hd.task_id,'post','new')
        })
      }
      // Connect insert, delete row on put
      if (trst.task.acc.hd.action == 'put'){
        dojo.query('select').onchange(function(e){
          if (selectedValue(e.target) != 'null'){
            trst.task.acc.stock.insertRow(selectedLabel(e.target),trst.task.acc.hd.object_id,selectedValue(e.target))
          }
        })
        dojo.query('span.db-freight-del').onclick(function(e){
          trst.task.acc.stock.deleteRow(e.target)
        })
      }
      // Connect buttons ('Save','Cancel','Delete', etc.) except 'Post'
      this.connectButtons()
    },
    insertRow: function(name,doc_id,freight_id){
      var i = dojo.query('tr.freight').length, ii = 1;
      var lastRow = dojo.query('tr.freight')[i - 1];
      var newRow = dojo.clone(lastRow);
      newRow.children[0].children[0].innerHTML = name;
      (newRow.children[2].children.length) == 4 ? ii = 1 : ii = 0
      newRow.children[2].children[ii].name = '[freights][' + i + '][doc_id]'
      newRow.children[2].children[ii].value = doc_id
      newRow.children[2].children[ii + 1].name = '[freights][' + i + '][freight_id]'
      newRow.children[2].children[ii + 1].value = freight_id
      newRow.children[2].children[ii + 2].name = '[freights][' + i + '][pu]'
      newRow.children[2].children[ii + 2].value = "0.00"
      if (ii == 1)
        dojo.destroy(newRow.children[2].children[0])
      newRow.children[3].children[0].name = '[freights][' + i + '][qu]'
      newRow.children[3].children[0].value = "0.00"
      dojo.place(newRow,lastRow,'after')
    },
    deleteRow: function(node){
      dojo.addClass(node.parentElement.parentElement, 'hidden')
      node.parentNode.previousElementSibling.children[0].value = '-999'
    },
    connectButtons: function(){
      var bs = dojo.query('.button.save.mc-evt'),
          bp = dojo.query('.button.put.mc-evt'),
          bc = dojo.query('.button.cancel.mc-evt'),
          bd = dojo.query('.button.delete.mc-evt');
      bs.onclick(function(){
        trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
      })
      bp.onclick(function(){
        trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
      })
      bc.onclick(function(){
        trst.task.destroy()
      })
      bd.onclick(function(){
        trst.task.init(trst.task.acc.hd.task_id,'delete',trst.task.acc.hd.object_id)
      })
    }
  }
})
