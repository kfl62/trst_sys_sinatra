var task = {
  verb: 'get',
  connections: new Array,
  taskOverlay: dojo.create('div',{id:"task_overlay"}),
  taskWindow: dojo.create('div',{id:"task_window"}),
  xhrGet: function(id,verb){
    var verb = verb || this.verb,
    xhrArgs = {
      url: '/srv/tsk/' + verb + '/' + id,
      load: function(data){
        task.drawBox(data)
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
      dojo.publish('xhrMsg',['error','error',error])
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
  },
  positionBox: function(o1,o2){
    var lastX,lastY,tskww,tskwh,
    base = dojo.position(o1),
    tskw = dojo.position(o2);
    tskww = (tskw.w < 200) ? 200 : tskw.w;
    tskwh = (tskw.h < 200) ? 200 : tskw.h;
    lastX = base.x + 15;
    lastY = base.y + 10;
    dojo.style(o2,{
      left:   lastX + 'px',
      top:    lastY + 'px',
      width:  tskww + 'px',
      height: tskwh + 'px'
    });
  },
  drawBox: function(data){
    if (dojo.query('[id^="task"]').length == 0){
      var ovl = this.taskOverlay;
      var win = this.taskWindow;
      win.innerHTML = data;
      dojo.place(ovl,dojo.body(),'first');
      dojo.place(win,ovl,'after');
      this.positionBox(dojo.byId('xhr_content'),win);
    }
  },
  destroy: function(){
    dojo.query('[id^="task"]').forEach("dojo.destroy(item)");
  },
  connect: function(){
    dojo.forEach(this.connections, dojo.disconnect);
    this.connections.length = 0;
    dojo.query('#sidebar ul > li > a').forEach(function(a){
      task.connections.push(
        dojo.connect(a, 'onclick', function(e){
          e.preventDefault()
          task.xhrGet(e.target.id)
        })
      )
    })
  }
}
function init(){
  task.connect();
}
dojo.addOnLoad(init);
