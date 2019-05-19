(function() {
  App.Service.Feedback = {
    fetch_actual: function() {
      $.getScript('/service/actual_feedbacks.js');
    }
  };

  $(function() {
    if ($('#feedback_notifications-link').length > 0) {
      App.Service.Feedback.fetch_actual();
    }
  })
}).call(this);
