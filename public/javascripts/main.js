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
    module = function(name) {
      return window[name] = window[name] || {};
    };
    if ($('body').attr('id') == 'public'){
      require(['public/main'], function(){
        Trst.init()
      })
    } else {
      require(['system/main'], function(){
        Trst.init()
      })
    }
  })
})
