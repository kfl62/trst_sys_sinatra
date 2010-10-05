dojo.provide("trst.auth");
trst.auth = {
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
        node.innerHTML = data;
        dojo.connect(dojo.byId('login_pass'),'onkeypress',function(e){
            if (e.keyCode == 13)
            trst.auth.submit();
        });
        dojo.connect(dojo.byId('login_button'),'onclick',function(e){
            trst.auth.submit();
        });
      }
    })
  },
  submit: function(){
    dojo.byId('form_auth').submit();
    this.destroy();
  },
  destroy: function(){
    dojo.query('[id^="auth"]').forEach("dojo.destroy(item)")
  }
}
