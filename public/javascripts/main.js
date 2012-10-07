require.config({
  paths: {
    'jquery': 'http://yandex.st/jquery/1.8.2/jquery.min',
    'jquery-ui': 'http://yandex.st/jquery-ui/1.8.23/jquery-ui.min',
    'async': 'plugins/async'
  },
  priority: ['jquery']
})

require(['jquery','/javascripts/libs/jquery.ba-tinypubsub.min.js'], function($){
  $(function(){
    Trst = {debug: true};
    $log = function(txt){
      if (Trst.debug){
        console.log(txt)
      }
    };
    if ($('body').attr('id') == 'public'){
      require(['public/main'], function(){
        Trst.init()
      })
    } else {
      require(['system/main'], function(){
        if ($('body').data('js_module_path')){
          var js_module_path = $('body').data('js_module_path')
          var module  = js_module_path.substr(0,1).toUpperCase() + js_module_path.substr(1)
          window[module] = {}
          require([js_module_path + '/main'], function(module){
            Trst.module = module
            Trst.init()
            module.init()
          })
        } else {
          Trst.init()
        }
      })
    }
  })
})
