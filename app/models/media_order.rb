class MediaOrder < ActiveRecord::Base
  attr_accessible :content, :name, :phone, :time

  def header
    [
      "Заказ от #{time.strftime('%d.%m.%Y %H:%M:%S.')}\n\n",
      "Имя: #{name}\n",
      "Телефон: #{phone}\n\n\n",
    ].join
  end

  def full_content
    header + content
  end
end
