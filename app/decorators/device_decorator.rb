class DeviceDecorator < ItemDecorator
  delegate_all

  def last_service_job
    ServiceJob.where(item_id: object.id).order(created_at: :desc).first
  end

  def security_code
    last_service_job&.security_code
  end

  def app_store_pass
    last_service_job&.app_store_pass
  end

  def serviced_last_time
    if last_service_job.present?
      "#{h.distance_of_time_in_words_to_now(last_service_job.created_at)} #{I18n.t('ago')}".html_safe
    else
      nil
    end
  end
end
