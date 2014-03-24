class Entities::RepairServiceEntity < Grape::Entity
  expose :id, :name, :price, :client_info
  expose :spare_parts do |repair_service, options|
    repair_service.spare_parts.map do |spare_part|
      {id: spare_part.id, name: spare_part.name, status: I18n.t("spare_parts.remnants.#{spare_part.remnant_s(options[:store])}")}
    end
  end
end