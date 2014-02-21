module CaseColorsHelper

  def case_color_presentation(case_color)
    if case_color.present?
      content_tag(:span, class: 'case_color') do
        content_tag(:div, nil, class: 'color_icon', style: "background-color: #{case_color.color || 'transparent'}") +
        case_color.name.html_safe
      end
    else
      '-'
    end
  end

end
