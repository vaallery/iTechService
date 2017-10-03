module IndexCell
  def self.included(base)
    base.class_eval do
      private

      include ModelCell
      property :model_name
      alias_method :collection, :model
    end
  end

  private

  def new_link(**options)
    options[:class] = 'btn btn-success btn-large'
    name ||= I18n.t("#{model_name.collection}.new.title", default: t('new'))
    link_to url_for(controller: model_name.route_key, action: 'new'), options do
      "#{icon(:plus)} #{name}".html_safe
    end
  end

  def nothing_found_message
    content_tag :h2, I18n.t('errors.nothing_found')
  end

  def pagination
    # view_context.will_paginate collection, class: 'digg_pagination'
  end
end