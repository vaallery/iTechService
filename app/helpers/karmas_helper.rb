module KarmasHelper

  def karma_comment(karma)
    content_tag(:span) do
      concat content_tag(:span, "#{karma.user_presentation} [#{l karma.created_at, format: :date_short}]")
      concat tag(:br)
      concat content_tag(:span, karma.comment)
    end.html_safe
  end

  def link_to_add_karma(user, good, options={})
    icon_name = good ? 'thumbs-up' : 'thumbs-down'
    class_name = 'new_karma_link '
    class_name << (good ? 'good ' : 'bad ')
    class_name << options[:class]
    link_to glyph(icon_name), new_karma_path(karma: {user_id: user.id, good: good}), class: class_name, remote: true, id: "new_#{(good ? 'good' : 'bad')}_karma_for_#{user.id}"
  end

  def header_karma_button
    content_tag(:li, id: 'header_karma_button') do
      #link_to "#{glyph('thumbs-up')}/#{glyph('thumbs-down')}".html_safe, '#', rel: 'popover', data: { html: true, placement: 'bottom', title: button_to_close_popover.gsub('/n', ''), content: header_karma_form.gsub('/n', '') }
      #link_to "#{glyph('thumbs-up')}/#{glyph('thumbs-down')}".html_safe, '#', rel: 'popover', id: 'header_karma_link', data: { html: true, placement: 'bottom', title: button_to_close_popover.gsub('/n', ''), content: render('karmas/header_form').html_safe.gsub('/n', '') }
      link_to "#{glyph('thumbs-up')}/#{glyph('thumbs-down')}".html_safe, '#', rel: 'popover', id: 'header_karma_link', data: { html: true, placement: 'bottom', title: button_to_close_popover.gsub('/n', ''), content: header_karma_form.gsub('/n', '') }
    end
  end

  def header_karma_form
    users_list = User.active.map { |user| [user.short_name, user.id] }
    form_tag(karmas_path, method: :post, remote: true, id: 'header_karma_form') do
      #text_field_tag('karma[user]', nil, id: 'header_karma_user', data: { provide: 'typeahead', source: users_list })
      select(:karma, :user_id, users_list, { include_blank: true }) +
      hidden_field(:karma, :good, id: 'header_karma_good') +
      content_tag(:div, class: 'btn-group', 'data-toggle' => 'buttons-radio') do
        button_tag(glyph('thumbs_up'), class: 'btn btn-success', id: 'header_karma_good_true', type: 'button') +
        button_tag(glyph('thumbs_down'), class: 'btn btn-danger', id: 'header_karma_good_false', type: 'button')
      end +
      "<textarea id='karma_comment' name='karma[comment]' rows='3'></textarea>".html_safe +
      button_tag(glyph(:save)+' '+t(:save), class: 'btn btn-primary')
    end
  end

end
