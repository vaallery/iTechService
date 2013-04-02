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
    link_to icon_tag(icon_name), new_karma_path(karma: {user_id: user.id, good: good}), class: class_name, remote: true,
            id: "new_#{(good ? 'good' : 'bad')}_karma_for_#{user.id}"
  end

end
