module Service
  module DeviceTasks
    class Update < ATransaction
      step :validate
      check :check_remnants
      step :save
      tee :notify

      private

      def validate(params, device_task)
        device_task.attributes = params

        device_task.valid? ? Success(device_task) : Failure(device_task)
      end

      def check_remnants(device_task)
        store = Department.current.spare_parts_store

        device_task.repair_tasks.each do |repare_task|
          repare_task.repair_parts.each do |repair_part|
            defect_qty_diff = repair_part.defect_qty - (repair_part.defect_qty_was || 0)
            quantity_need = defect_qty_diff
            quantity_need += repair_part.quantity if repare_task.new_record?

            if repair_part.store_item(store).quantity < quantity_need
              device_task.errors[:base] << I18n.t('device_tasks.errors.insufficient_spare_parts', name: repair_part.name)
            end
          end
        end

        device_task.errors.empty?
      end

      def save(device_task, warranty_item_ids)
        ActiveRecord::Base.transaction do
          begin
            if device_task.is_repair?
              device_task.repair_tasks.each do |repare_task|
                if repare_task.new_record?
                  defect_sp_store = Store.current_defect_sp
                  warranty_item_ids.map!(&:to_i)

                  repare_task.repair_parts.each do |repair_part|
                    repair_part.stash
                    repair_part.move_defected if repair_part.defect_qty > 0
                    repair_part.store_item(defect_sp_store).add if warranty_item_ids.include?(repair_part.item_id)
                  end
                else
                  repare_task.repair_parts.each(&:move_defected)
                end
              end
            end

            device_task.save!
          rescue ActiveRecord::Rollback
            return Failure(device_task)
          end
        end

        Success(device_task)
      end

      def notify(device_task, user, params)
        Service::DeviceSubscribersNotificationJob.perform_later(device_task.service_job_id, user.id, params)
      end
    end
  end
end
