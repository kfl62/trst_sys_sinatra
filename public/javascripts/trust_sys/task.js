dojo.provide("trst.task");
var task = {
  id: "",
  verb: "",
  target_id: "",
  url: ["/srv/tsk"],
  connections: new Array,
  actions: new Array,
  taskOverlay: dojo.create('div',{id:"task_overlay"}),
  taskWindow: dojo.create('div',{id:"task_window"}),
  init: function(id,verb,target_id){
    this.id = id;
    if (verb == undefined){
      this.verb = "filter"
      this.url.push(this.id,this.verb);
      this[this.verb]()
    }else if (verb == 'help'){
      this.verb = "help"
      this.url.push(this.id,this.verb);
      this[this.verb]()
    }else{ 
      var referrer = /filter|get/
      if (referrer.test(this.verb)){
        this.url.push(this.id,verb,target_id);
        this.verb = verb;
        this.get();
      }else{
        this.verb = verb;
        this.url.push(this.id,verb,target_id);
        this[this.verb]();
      }
    }
  },
  filter: function(){
    var xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error])
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  help: function(){
    var xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        dojo.byId('xhr_content').innerHTML = data;
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error])
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  get: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
      dojo.publish('xhrMsg',['error','error',error])
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  positionBox: function(o1,o2){
    var lastX,lastY,tskww,tskwh,
    base = dojo.position(o1),
    tskw = dojo.position(o2);
    lastX = base.x + 18;
    lastY = base.y + 18;
    dojo.style(o2,{
      left:   lastX + 'px',
      top:    lastY + 'px'
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
    else{
      dojo.destroy(dojo.byId('task_window'))
      var ovl = dojo.byId('task_overlay');
      var win = this.taskWindow;
      win.innerHTML = data;
      dojo.place(win,ovl,'after');
    }
  },
  destroy: function(){
    dojo.query('[id^="task"]').forEach("dojo.destroy(item)");
    this.id = this.verb = this.target_id = "";
    this.url = ["/srv/tsk"];
  },
  connect: function(){
    dojo.forEach(this.connections, dojo.disconnect);
    this.connections.length = 0;
    dojo.query('#sidebar ul > li > a').forEach(function(a){
      task.connections.push(
        dojo.connect(a, 'onclick', function(e){
          e.preventDefault()
          task.init(e.target.id)
        })
      )
    })
  }
}
function init(){
  task.connect();
}
dojo.addOnLoad(init);
