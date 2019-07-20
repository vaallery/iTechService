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
              device_task.errors[:base] << I18n.t('device_tasks.errors.insufficient_spare_parts',
                                                  store: store.name, spare_part: repair_part.name)
            end
          end
        end

        device_task.errors.empty?
      end

      def save(device_task, warranty_item_ids, user)
        ActiveRecord::Base.transaction do
          begin
            if device_task.is_repair?
              defected_items = []

              device_task.repair_tasks.each do |repare_task|
                if repare_task.new_record?
                  defect_sp_store = Store.current_defect_sp
                  warranty_item_ids = warranty_item_ids&.map(&:to_i) || []

                  repare_task.repair_parts.each do |repair_part|
                    repair_part.stash
                    if repair_part.defect_qty > 0
                      defected_items << {id: repair_part.item_id, qty: repair_part.defect_qty}
                    end
                    repair_part.store_item(defect_sp_store).add if warranty_item_ids.include?(repair_part.item_id)
                  end
                else
                  repare_task.repair_parts.each do |repair_part|
                    # TODO Check
                    qty = repair_part.defect_qty - (repair_part.defect_qty_was || 0)
                    if qty > 0
                      defected_items << {id: repair_part.item_id, qty: qty}
                    end
                  end
                end
              end

              move_defected(defected_items, device_task, user) if defected_items.any?
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

      def move_defected(items, device_task, user)
        movement_act = MovementAct.create(store_id: device_task.department.spare_parts_store.id,
                                          dst_store_id: device_task.department.defect_sp_store.id,
                                          user_id: user.id,
                                          comment: "Списание брака при ремонте.",
                                          date: DateTime.current)

        items.each do |item|
          movement_act.movement_items.create(item_id: item[:id], quantity: item[:qty])
        end

        movement_act.post
      end
    end
  end
end
