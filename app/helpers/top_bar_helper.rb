module TopBarHelper
  def header_link_to_feedbacks
    link_to glyph('phone'), '#', id: 'feedback_notifications-link', rel: 'popover',
            data: {html: true, placement: 'bottom', content: ''}
  end

  def header_links_to_stale_jobs
    1.upto(2).map { |i|
      link_to(glyph('inbox'), '#', id: "stale_jobs-link-#{i}", class: 'notification', rel: 'popover',
              data: {html: true, placement: 'bottom', content: ''})
    }.join(' ').html_safe
  end

  def link_to_trade_in_purgatory
    if can?(:manage, TradeInDevice) && TradeInDevice.unconfirmed.any?
      link_to(t('trade_in_device.purgatory'), purgatory_trade_in_devices_path)
    end
  end
end
