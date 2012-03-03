dojo.mixin(trst.task.acc,{
  cache: {
    init: function(){
      // Connect select, 'Post' on filter
      if (trst.task.acc.hd.action == 'filter'){
        dojo.query('select.dp').onchange(function(e){
          if (selectedValue(e.target) != 'null'){
            trst.task.init(trst.task.acc.hd.task_id,'get',selectedValue(e.target))
          }
        })
        dojo.query('.button.post.mc-evt').onclick(function(){
           trst.task.init(trst.task.acc.hd.task_id,'post','new')
        })
      }
      // Connect buttons ('Save','Cancel','Delete', etc.) except 'Post'
      this.connectButtons()
    },
    connectButtons: function(){
      dojo.query('.button.save.mc-evt').onclick(function(){
        trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
      })
      dojo.query('.button.put.mc-evt').onclick(function(){
        trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
      })
      dojo.query('.button.cancel.mc-evt').onclick(function(){
        trst.task.destroy()
      })
      dojo.query('.button.delete.mc-evt').onclick(function(){
        trst.task.init(trst.task.acc.hd.task_id,'delete',trst.task.acc.hd.object_id)
      })
    }
  }
})
