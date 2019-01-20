App.TradeInDevices = {
  toggle_guarantee: function(){
    var apple_guarantee = document.getElementById('trade_in_device_apple_guarantee');
    var extended_guarantee = document.getElementById('trade_in_device_extended_guarantee');
    apple_guarantee.toggleAttribute('disabled');
    extended_guarantee.toggleAttribute('disabled');
    apple_guarantee.value = '';
    extended_guarantee.checked = false;
  }
};
