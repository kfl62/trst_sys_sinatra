dojo.provide("trst.auth");
var loginBox = {
  init: function(){
    if (dojo.query('[id^="auth"]').length == 0){
      this.auth_overlay();
      this.auth_login();
    }
  },
  auth_overlay: function(){
    dojo.create('div',{id:"auth_overlay"},dojo.body(),'first')
  },
  auth_login: function(){
    var node = dojo.create('div',{id:"auth_login"},'auth_overlay','after')
    dojo.xhrGet({
      url: '/auth/login',
      load: function(data){
        node.innerHTML = data
      }
    })
  },
  destroy: function(){
    dojo.query('[id^="auth"]').forEach("dojo.destroy(item)")
  }
}

