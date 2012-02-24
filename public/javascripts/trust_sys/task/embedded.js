dojo.mixin(trst.task,{
  embedded: {
    filter: function(task_id,step,selected){
      var node = dojo.byId('task_window')
      trst.task.url.push(task_id,'filter');
      var xhrArgs = {
        url: trst.task.url.join('/').concat('?step=',step,'&child_id=',selected),
        load: function(data){
          node.innerHTML = data;
        },
        error: function(error){
          trst.task.destroy();
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.url = ["/srv/tsk"];
    },
    get: function(task_id,goal_id,child_id,goal){
      var node = dojo.byId('task_window')
      trst.task.url.push(task_id,'get',goal_id);
      var xhrArgs = {
        url: trst.task.url.join('/').concat('?goal=',goal,'&child_id=',child_id),
        load: function(data){
          node.innerHTML = data;
        },
        error: function(error){
          trst.task.destroy();
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.url = ["/srv/tsk"];
    }
  }
})
