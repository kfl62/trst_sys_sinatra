var sysMsg = dojo.subscribe('xhrMsg',function(what,kind,data){
  var p = what;
  kind ? p += '/' + kind : p += '/info'
  data ? p += '?data=' + data : p += ''  
  var info_node = dojo.byId('xhr_msg'),
      anim = dojo.animateProperty({
        node: info_node,
        duration: 1000,
        properties:{
          opacity: {end: 0, start: 1}
        },
        onEnd: function(){
          dojo.attr(info_node,'class','hidden');        
        }
      });
  dojo.xhrGet({
    handleAs: 'json',
    url: '/utils/msg/' + p,
    load: function(data){
      if (data){
        info_node.innerHTML = data.msg.txt;
        dojo.attr(info_node,'class',data.msg.class);
        dojo.style(info_node,{'opacity': 1});
        if (what != "loading")
          anim.play(2000);
      }
    }
  });
})

var xhrMenu = function(param){
  if (dojo.body().id == 'srv')
    param = 'srv/' + param
  var content_node = dojo.byId('xhr_content'),
      xhrParams = {
    url: '/' + param,
    load: function(data){
      content_node.innerHTML = data;
      dojo.attr('xhr_msg','class','hidden');
      if (param.replace('srv/','') == dojo.body().dataset.dailytaskspage)
        xhrInitSidebar();
    },
    error: function(error){
      dojo.publish('xhrMsg',['error','error',error])
    }
  };
  dojo.publish('xhrMsg',['loading','info']);
  var defered = dojo.xhrGet(xhrParams)
}

var xhrInitSidebar = function(){
  var content_node = dojo.byId('xhr_tasks'),
  xhrParams = {
    url: '/srv/tsk/',
    load: function(data){
      content_node.innerHTML = data;
    },
    error: function(error){
      dojo.publish('xhrMsg',['error','error',error])
    }
  };
  var defered = dojo.xhrGet(xhrParams)
}

function init(){
  if (dojo.body().id == 'srv'){
    dojo.require('trst.task',true)
  }else{
    dojo.require('trst.auth',true)
  }
  dojo.publish('xhrMsg',['flash']);
  dojo.query('#menu ul > li > a')
  .onclick(function(e){
    e.preventDefault();
    xhrMenu(e.target.id);
  })
}
dojo.addOnLoad(init);