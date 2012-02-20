dojo.require("dojo.data.ItemFileReadStore")
dojo.require("dijit.form.FilteringSelect")
dojo.provide("trst.task");
trst.task = {
  // variables {{{1
  id: "",
  verb: "",
  target_id: "",
  url: ["/srv/tsk"],
  connections: new Array,
  actions: new Array,
  taskOverlay: dojo.create('div',{id:"task_overlay"}),
  taskWindow: dojo.create('div',{id:"task_window"}),
  // functions {{{1
  // init {{{2
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
  // filter {{{2
  filter: function(){
    var xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        trst.task.acc.init();
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  //set unit_id {{{2
  unit_id: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        trst.task.acc.init();
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // help {{{2
  help: function(){
    var xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        dojo.byId('xhr_content').innerHTML = data;
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // get {{{2
  get: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        trst.task.acc.init();
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // pdf get params {{{2
  pdf: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // pdf generate {{{2
  print: function(){
    xhrArgs = {
      form: dojo.query('form')[0],
      url: this.url.join('/'),
      load: function(data){
        window.location = this.url;
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrPut(xhrArgs);
    this.destroy();
  },
  //query get params {{{2
  query: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
        trst.task.acc.init();
        if (trst.task.acc.cpus != null){
          trst.task.acc.calculatorInv();
        }
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // error handling page {{{2
  repair: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // not ready page {{{2
  test: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // post {{{2
  post: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        dojo.publish('xhrMsg',['flash']);
        trst.task.drawBox(data);
        trst.task.acc.init();
        if (trst.task.acc.cpus != null){
          trst.task.acc.calculatorInv();
        }
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    var deferred = dojo.xhrPost(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // put {{{2
  put: function(){
    xhrArgs = {
      form: dojo.query('form')[0],
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.publish('xhrMsg',['flash']);
        trst.task.acc.init();
     },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    var deferred = dojo.xhrPut(xhrArgs);
    this.url = ["/srv/tsk"];
    this.verb = "get";
  },
  // delete {{{2
  delete: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        dojo.publish('xhrMsg',['flash']);
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    var deferred = dojo.xhrDelete(xhrArgs);
    this.destroy();
  },
  // position the taskWindow{{{2
  positionBox: function(o1,o2){
    var lastX,lastY,tskww,tskwh,
    base = dojo.position(o1),
    tskw = dojo.position(o2);
    lastX = base.x + 18;
    lastY = (o2.offsetHeight > 476) ? base.y + (482 - o2.offsetHeight) : base.y + 18;
    dojo.style(o2,{
      left:   lastX + 'px',
      top:    lastY + 'px'
    });
  },
  // draw the taskWindow{{{2
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
      this.positionBox(dojo.byId('xhr_content'),win);
    }
    if (dojo.query('table.big').length > 0){
      var tbl = dojo.query('table.big')[0]
      if (tbl.scrollHeight > tbl.clientHeight){
        tbl.style.width = (tbl.offsetWidth + 16) + 'px'
      }else{
        tbl.style.width = (tbl.offsetWidth + 1) + 'px'
      }
    }
  },
  // destroy the taskWindow and reset vars{{{2
  destroy: function(){
    dojo.query('[id^="task"]').forEach("dojo.destroy(item)");
    this.id = this.verb = this.target_id = "";
    this.url = ["/srv/tsk"];
  },
  // connect tasks in sidebar{{{2
  connect: function(){
    dojo.forEach(this.connections, dojo.disconnect);
    this.connections.length = 0;
    dojo.query('#sidebar ul > li > a').forEach(function(a){
      if (a.getAttribute('data-tsks') == 'filter'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id)
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'pdf'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'pdf')
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'query'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'query')
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'repair'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'repair','null')
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'test'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'test')
          })
        )
      }
    })
  }
}
// initialize on load{{{2
function init(){
  dojo.require('trst.task.embedded')
  dojo.require('trst.task.relations')
  dojo.require('trst.task.acc')
  trst.task.connect();
}
dojo.addOnLoad(init);
