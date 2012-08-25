require.config({
  paths: {
    'jquery': 'http://yandex.st/jquery/1.7.2/jquery.min',
    'jquery-ui': 'http://yandex.st/jquery-ui/1.8.18/jquery-ui.min',
    'async': 'plugins/async'
  },
  priority: ['jquery']
})

require(['jquery','/javascripts/libs/jquery.ba-tinypubsub.min.js'], function($){
  $(function(){
    Trst = {
      debug: true,
      desk: {
        buttons: {
          action: {}
        },
        select: {},
        relations: {},
        tabs: {}
      }
    };
    $msg = function(txt){
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
        if ($('body').data('js_path')){
          var js_path = $('body').data('js_path')
          var module  = js_path.substr(0,1).toUpperCase() + js_path.substr(1)
          Trst.module = module
          require([js_path + '/module'], function(){
            Trst.module = window[Trst.module]
          })
        }
        Trst.init()
      })
    }
  })
})
