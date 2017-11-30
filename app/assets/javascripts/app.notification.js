App.Notification = {

  getContainer: function(){
    return document.getElementById('notifications_container')
  },

  show: function(content) {
    var container = App.Notification.getContainer();
    $(container).append(content);
  },

  // appendFlash: function(content) {
  //   var $container = App.Notification.container();
  //   $container.append(content);
  //   return setTimeout(function() {
  //     return $container.find('.alert:first-child').remove();
  //   }, 10000);
  // }
};