dojo.provide("trst.task");
var task = {
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
        task.drawBox(data);
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
        task.drawBox(data);
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
        task.drawBox(data);
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
        dojo.publish('xhrMsg',['flash']);
        task.drawBox(data);
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
    lastY = base.y + 18;
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
      task.connections.push(
        dojo.connect(a, 'onclick', function(e){
          e.preventDefault()
          task.init(e.target.id)
        })
      )
    })
  }
}
  // mixin for handling relations {{{2
dojo.mixin(task,{
  relations: {
    relationsOverlay: dojo.create('div',{id:"relations_overlay"}),
    relationsWindow: dojo.create('div',{id:"relations_window"}),
    init: function(){
      this.parentNode = event.target.parentNode;
      var ovl = this.relationsOverlay,
          win = this.relationsWindow,
          target = event.target;
      this.url = this.parentNode.children[2].value.split(',')
      this.url.push(target.dataset.fieldname);
      this.url.push(target.className.split('-').pop());
      var pos = dojo.position(this.parentNode);
      dojo.style(win,{
        left: pos.x + 'px',
        top:  pos.y + 'px'
      });
      dojo.xhrGet({
        url: this.url.join('/'),
        load: function(data){
          win.innerHTML = data;
          dojo.place(ovl,task.taskWindow,'after');
          dojo.place(win,ovl,'after');
        },
        error: function(error){
          task.relations.destroy();
          task.destroy();
          dojo.publish('xhrMsg',['error','error',error]);
        }
      })
    },
    add: function(){
      var span = this.parentNode.children[0],
          names = (span.innerHTML == "") ? [] : span.innerHTML.split(', '),
          input = this.parentNode.children[1],
          ids = (input.value == "") ? [] : input.value.split(','),
          selected = dojo.query('#relations_window option:checked')[0];
      if (selected.value != 'null'){
        names.push(selected.text);
        ids.push(selected.value);
      };
      span.innerHTML = names.join(', ');
      input.value = ids.join(',');
      this.destroy();
    },
    del: function(){
      var span = this.parentNode.children[0],
          names = span.innerHTML.split(', '),
          input = this.parentNode.children[1],
          ids = input.value.split(','),
          selected = dojo.query('#relations_window option:checked')[0];
      if (selected.value != 'null'){
        names.splice(dojo.indexOf(names,selected.text),1);
        ids.splice(dojo.indexOf(selected.value),1);
      };
      span.innerHTML = names.join(', ');
      input.value = ids.join(',');
      this.destroy();
    },
    destroy: function(){
      dojo.query('[id^="relations"]').forEach("dojo.destroy(item)");
      this.url.length = 4;
    }
  }
})

  // initialize on load{{{2
function init(){
  task.connect();
}
dojo.addOnLoad(init);
