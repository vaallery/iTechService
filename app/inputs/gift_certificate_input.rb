class GiftCertificateInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:div, class: 'gift_certificate_input') do
      @builder.hidden_field("#{attribute_name}_id", class: 'gift_certificate_id') +
      template.link_to(template.human_gift_certificate_nominal(@builder.object.gift_certificate) || template.t('gift_certificates.scan'), '#', class: 'scan_gift_certificate_link btn has-tooltip', title: template.human_gift_certificate_balance(@builder.object.gift_certificate))
    end
  end

end
