class Sync::DataSyncJob < Struct.new(:params)

  TIME_FORMAT = "%Y.%m.%d %H:%M:%S"

  def name
    "Data sunc {#{params.inspect}}"
  end

  def perform
    if Department.current.present? and Department.current.is_main?
      if remote_dep_code.present? and ActiveRecord::Base.configurations["#{Rails.env}_#{remote_dep_code}"].present?
        #
      end
    end
  end

  private

  def sync_shared_data

  end

  def local_model(class_name)
    model_class = class_name.constantize
    model_class.establish_connection Rails.env
    model_class
  end

  def remote_model(class_name)
    model_class = class_name.constantize
    model_class.establish_connection "#{Rails.env}_#{remote_dep_code}"
    model_class
  end

  def remote_dep_code
    @remote_dep_code ||= params[:remote_dep]
  end

end