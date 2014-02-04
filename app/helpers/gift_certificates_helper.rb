module GiftCertificatesHelper

  def gift_certificate_history_tag(certificate, full=nil)
    if certificate.issued? or full
      history = (full ? certificate.history_records : certificate.history_since_issue).reorder('created_at asc')
      content_tag(:ul, class: 'unstyled') do
        prev_consumed = 0
        history.map do |rec|
          case rec.column_name
            when 'nominal'
              value = human_currency rec.new_value
            when 'status'
              value = t("gift_certificates.statuses.#{GiftCertificate::STATUSES[rec.new_value.to_i]}")
              prev_consumed = 0 if rec.new_value.to_i == 1
            when 'consumed'
              new_consumed = rec.new_value.to_i
              value = new_consumed - prev_consumed
              prev_consumed = new_consumed
            else
              value = rec.new_value
          end
          content_tag(:li) do
            "[#{l(rec.created_at, format: :long_d)}] #{GiftCertificate.human_attribute_name(rec.column_name)}: #{value}"
          end
        end.join.html_safe
      end.html_safe
    else
      nil
    end
  end

  def human_gift_certificate_nominal(gift_certificate)
    gift_certificate.present? ? human_currency(gift_certificate.nominal) : nil
  end

  def human_gift_certificate_balance(gift_certificate)
    gift_certificate.present? ? t('gift_certificates.balance_value', value: gift_certificate.balance) : ''
  end

end
