class DataStorageInput < SimpleForm::Inputs::CollectionInput
  delegate :content_tag, :link_to, :current_user, :check_box_tag, to: :template
  delegate :data_storages, to: :object

  def input(wrapper_options = nil)
    content_tag :div, class: 'dropdown-input data_storage-input' do
      content_tag(:span, class: 'btn-group') do
        content_tag(:button, class: 'btn dropdown-toggle', 'data-toggle' => 'dropdown') do
          content_tag(:span, class: 'input-presentation pull-left') do
            data_storages.any? ? data_storages.join(', ') : '-'
          end +
          content_tag(:span, nil, class: 'caret pull-right')
        end +
        content_tag(:ul, class: 'dropdown-menu') do
          available_data_storages.map do |storage_num, storage_name|
            content_tag(:li, class: 'dropdown-input-item') do
              content_tag(:label) do
                check_box(storage_name, storage_num) + data_storage_presentation(storage_name)
              end
            end
          end.join.html_safe
        end
      end
    end
  end

  private

  def data_storage_presentation(storage_name)
    content_tag(:span, storage_name, class: 'data_storage-label')
  end

  def check_box(storage_name, storage_num)
    check_box_tag("#{object_name}[#{attribute_name}][]", storage_name, data_storage_selected?(storage_name),
                  id: "#{object_name}-#{attribute_name}-#{storage_num}", class: 'data_storage-checkbox')
  end

  def data_storage_selected?(storage_name)
    data_storages.include?(storage_name)
  end

  def available_data_storages
    storages = []

    Department.current_with_remotes.each do |department|
      qty = Setting.data_storage_qty(department)
      return [] if qty.nil?

      storages += 1.upto(qty).map { |storage_num| [storage_num, "#{department.name} - #{storage_num}"] }
    end

    storages
  end
end
