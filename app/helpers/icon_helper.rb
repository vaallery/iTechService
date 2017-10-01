module IconHelper
  def icon(*names)
    names.map! { |name| name.to_s.gsub('_','-') }
    names.map! do |name|
      name =~ /pull-(?:left|right)/ ? name : "icon-#{name}"
    end
    content_tag :i, nil, :class => names
  end
end