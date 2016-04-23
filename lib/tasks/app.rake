namespace :app do

  desc 'Move repair parts of unarchived service_jobs to repair store'
  task stash_repair_parts: :environment do
    log = Logger.new('log/app_stash_repair_parts.log')
    # log = Logger.new(STDOUT)
    start_time = Time.now

    archive_id = Location.archive.id
    repair_store = Department.current.repair_store
    defect_sp_store = Department.current.defect_sp_store
    
    log.info "Task started at #{start_time}"

    RepairTask.includes(device_task: :service_job).where('service_jobs.location_id <> ?', archive_id).find_each do |repair_task|
      repair_task.repair_parts.each do |repair_part|
        log.info "RepairPart [#{repair_part.id}] #{'-' * 10}"
        if repair_part.item.present?
          log.info "Product [#{repair_part.product.id}] #{repair_part.name} "
          if repair_task.pending?
            sp_store = repair_part.store

            log.info "Moving (#{repair_part.quantity}) to repair store"
            repair_part.store_item(sp_store).move_to(repair_store, repair_part.quantity)
          
            if repair_part.defect_qty > 0
              log.info "Moving defected (#{repair_part.defect_qty}) #{repair_part.name}"
              repair_part.store_item(sp_store).move_to(defect_sp_store, repair_part.defect_qty)
            end
          end
          if repair_task.done?
            log.info "Adding (#{repair_part.quantity}) to repair store"
            repair_part.store_item(repair_store).add(repair_part.quantity)
          end
        else
          log.info "!!! Item absent"
        end
      end
    end

    end_time = Time.now
    duration = (end_time - start_time) / 1.minute
    log.info "Task finished at #{end_time} and last #{duration} minutes."
    log.close
  end

  desc "Set default value for device's 'is_tray_present'"
  task set_tray_presence: :environment do
    ServiceJob.find_each do |service_job|
      service_job.update_column(:is_tray_present, true) if service_job.is_tray_present.nil?
    end
  end

  desc "Set ServiceJobs items"
  task set_service_jobs_items: :environment do
    SetServiceJobsItems.new.call
  end
end
