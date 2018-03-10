module TopBarHelper
  def header_link_to_feedbacks
    link_to glyph('phone'), '#', id: 'feedback_notifications-link', rel: 'popover',
            data: {html: true, placement: 'bottom', content: ''}
  end
end
