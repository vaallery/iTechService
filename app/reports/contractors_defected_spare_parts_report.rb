class ContractorsDefectedSparePartsReport < BaseReport
  def call
    spare_part_defects = SparePartDefect.where(created_at: period).in_department(department)
    spare_parts = spare_part_defects.includes(item: :product).distinct.pluck(:item_id, 'products.name')
    data = {}

    spare_parts.each do |item_id, name|
      contractors = spare_part_defects.includes(:contractor).where(item_id: item_id).group('contractors.name').sum(:qty)
      data.store name, contractors
    end

    result[:data] = data
    self
  end
end
