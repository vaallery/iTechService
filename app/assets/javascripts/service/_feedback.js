(function() {
  App.Service.Feedback = {
    fetch_actual: function() {
      $.getScript('/service/actual_feedbacks.js');
    }
  };

  $(function() {
    App.Service.Feedback.fetch_actual();
  })
}).call(this);
