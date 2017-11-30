module RenderCell
  def render_cell(cell_class, model: nil, **options)
    model ||= @model
    # options[:layout] = Shared::Cell::Layout unless options.key? :layout
    options[:contract] = @form unless @form.nil?
    # options[:contract] = @contract unless @contract.nil?
    content = cell(cell_class, model, options).call

    # if request.xhr?
    #   render js: ''
    # else
    # end
    render html: content, layout: false
  end
end
