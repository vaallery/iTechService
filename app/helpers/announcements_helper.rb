module AnnouncementsHelper

  def announcement_content announcement
    case announcement.kind
      when 'help' then text = " #{t('announcements.needs_help')}"
      when 'coffee' then text = ": #{t('announcements.coffee_made')}"
      when 'for_coffee' then text = ": #{t('announcements.coffee_order', content: announcement.content)}"
      when 'protector' then text = ": #{t('announcements.protector_made')}"
      else text = ": #{announcement.content}"
    end
    "[#{l(announcement.created_at, format: :long_d)}] #{announcement.user.short_name}" + text
  end

  def header_link_to_announce
    case current_user.role
      when 'software' then icon = 'bell-alt'; kind = 'help'
      when 'media' then icon = 'coffee'; kind = 'coffee'
      when 'technician' then icon = 'file'; kind = 'protector'
      else return nil
    end
    if current_user.announced?
      state_class = 'active'
      link_path = cancel_announce_path(kind: kind)
    else
      state_class = ''
      link_path = make_announce_path(kind: kind)
    end
    content_tag(:li, id: 'announce_button', class: state_class) do
      link_to icon_tag(icon), link_path, method: :post, remote: true, id: 'announce_link', class: state_class
    end.html_safe
  end

  def header_link_for_coffee
    if current_user.software?
      coffee_order_form = form_tag(make_announce_path, remote: true, id: 'coffee_order_form', class: 'form-inline') do
        content_tag(:div, class: 'input-append') do
          hidden_field_tag(:kind, 'for_coffee') +
          text_field_tag(:content, nil, class: 'input-medium', autofocus: true) +
          submit_tag('OK', class: 'btn btn-primary')
        end +
        link_to(t('announcements.close_orders'), cancel_announce_path(kind: 'for_coffee'), method: :post, remote: true,
                class: 'btn btn-small')
      end.gsub('\n', '')

      content_tag(:li, id: 'coffee_order_button') do
        link_to icon_tag('coffee'), '#', remote: true, id: 'coffer_order_link',
                data: {html: true, placement: 'bottom', title: t('announcements.coffee_order_popover_title'),
                content: coffee_order_form}
      end
    else
      nil
    end
  end

end
