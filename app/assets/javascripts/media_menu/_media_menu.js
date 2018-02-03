(function() {
  window.MediaMenu || (window.MediaMenu = {});

  MediaMenu.storage = sessionStorage;

  MediaMenu.selected_items = function() {
    if (!this.storage.getItem('selected_items'))
      this.storage.setItem('selected_items', '');
    return this.storage.getItem('selected_items')
  };

  MediaMenu.mark_selected_items = function (){
    var items = this.selected_items().trim().split(',');
    items.forEach(function(item_id) {
      var $item = $('#media_menu-item_' + item_id);
      $item.addClass('selected');
    });
  };

  MediaMenu.add_item = function(id) {
    var items = this.selected_items();
    items += id + ',';
    this.storage.setItem('selected_items', items);
  };

  MediaMenu.remove_item = function(id) {
    var items = this.selected_items();
    items = items.replace(id + ',', '');
    this.storage.setItem('selected_items', items);
  };

  MediaMenu.remove_all_items = function() {
    this.storage.clear();
  };

  $(document).on('click', '[data-behaviour~=select-media_menu-item]', function() {
    var $item = $(this).closest('.media_menu-item');
    var id = $item.data('id');
    MediaMenu.add_item(id);
    $item.addClass('selected');
  });

  $(document).on('click', '[data-behaviour~=remove-media_menu-item]', function() {
    var $item = $(this).closest('.media_menu-item');
    var id = $item.data('id');
    MediaMenu.remove_item(id);
    $item.removeClass('selected');
  });

  $(document).on('click', '[data-behaviour~=remove-media_menu-order_item]', function() {
    var $item = $(this).closest('.media_menu-order_item');
    var id = $item.data('id');
    MediaMenu.remove_item(id);
    var new_location = window.location.href.split('?')[0];
    new_location += '?selected_items=' + MediaMenu.selected_items();
    window.location = new_location;
  });

  $(document).on('click', '[data-behaviour~=clear-media_menu-order]', function() {
    MediaMenu.remove_all_items();
  });

  $(function () {
    MediaMenu.mark_selected_items();

    $('[data-behaviour~=new-media_menu-order]').hover(function(event) {
      var $link = $(this);
      var href = $link.attr('href');
      var items = MediaMenu.selected_items();
      href = href.split('?')[0];
      href = href + '?selected_items=' + items;
      $link.attr('href', href);
    });
  });
}).call(this);

