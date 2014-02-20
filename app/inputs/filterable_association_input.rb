class FilterableAssociationInput < SimpleForm::Inputs::StringInput

  def input
    template.text_field_tag("#{attribute_name}_filter", nil, class: 'association_filter') +
    @builder.collection_check_boxes(attribute_name, options[:collection].all.map{|o|[o.id, o.name]}, :first, :last, collection_wrapper_tag: :div, collection_wrapper_class: 'list', item_wrapper_class: 'item') do |b|
      b.label(class: 'checkbox') { b.check_box(class: 'check_boxes') + b.text }
    end
  end

end