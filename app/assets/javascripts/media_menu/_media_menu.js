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
      MediaMenu.mark_item_selected(item_id);
    });
  };

  MediaMenu.add_item_to_store = function(id) {
    var items = this.selected_items();
    items += id + ',';
    this.storage.setItem('selected_items', items);
  };

  MediaMenu.remove_item_from_store = function(id) {
    var items = this.selected_items();
    items = items.replace(id + ',', '');
    this.storage.setItem('selected_items', items);
  };

  MediaMenu.remove_all_items = function() {
    this.storage.clear();
  };

  MediaMenu.select_item = function(item_id) {
    MediaMenu.add_item_to_store(item_id);
    MediaMenu.mark_item_selected(item_id);
  };

  MediaMenu.remove_item = function(item_id) {
    MediaMenu.remove_item_from_store(item_id);
    MediaMenu.unmark_item_selected(item_id)
  };

  MediaMenu.mark_item_selected = function(item_id) {
    $('.media_menu-item[data-id="' + item_id + '"]').addClass('selected');
  };

  MediaMenu.unmark_item_selected = function(item_id) {
    $('.media_menu-item[data-id="' + item_id + '"]').removeClass('selected');
  };

  $(document).on('click', '[data-behaviour~=remove-media_menu-order_item]', function() {
    var $item = $(this).closest('.media_menu-order_item');
    var id = $item.data('id');
    MediaMenu.remove_item_from_store(id);
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

