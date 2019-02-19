module Service
  module DeviceTasks
    class Update < ATransaction
      step :validate
      step :save
      tee :notify

      private

      def validate(params, device_task)
        device_task.attributes = params

        device_task.valid? ? Success(device_task) : Failure(device_task)
      end

      def save(device_task, warranty_item_ids)
        ActiveRecord::Base.transaction do
          begin
            if device_task.is_repair?
              device_task.repair_tasks.each do |repare_task|
                if repare_task.new_record?
                  repare_task.repair_parts.each do |repair_part|
                    repair_part.stash
                    repair_part.move_defected if repair_part.defect_qty > 0
                  end
                else
                  repare_task.repair_parts.each(&:move_defected)
                end
              end

              if warranty_item_ids.present?
                defect_sp_store = Store.current_defect_sp

                device_task.repair_parts.where(item_id: warranty_item_ids).each do |repare_part|
                  repare_part.store_item(defect_sp_store).add
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
