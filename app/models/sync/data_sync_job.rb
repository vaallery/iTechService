class Sync::DataSyncJob < Struct.new(:params)

  TIME_FORMAT = '%Y.%m.%d %H:%M:%S'
  MODES = %w[full update]
  COMMON_MODELS = %w[Bank CaseColor CashDrawer ClientCategory Department DeviceType ProductCategory ProductGroup Product Item FeatureType Feature Location PaymentType PriceType ProductPrice ProductRelation RepairGroup SparePart Setting StolenPhone Store StoreItem StoreProduct Task User]
  IMPORT_MODELS = %w[ClientCharacteristic GiftCertificate CashShift CashOperation Sale SaleItem Payment Device DeviceTask RepairTask StoreItem Client]

  def name
    "Data sync {#{params.inspect}}"
  end

  def perform
    if Department.current.present? and Department.current.is_main?
      if remote_dep_code.present? and ActiveRecord::Base.configurations["#{Rails.env}_#{remote_dep_code}"].present?
        case action
          when :export then export_data
          when :import then import_data
          else sync_data
        end
      end
    end
  end

  private

  def sync_data

  end

  def export_data
    _class_names = model_names || COMMON_MODELS
    _class_names.each do |class_name|
      export_table class_name
    end
  end

  def export_table(class_name)
    _local_model = local_model class_name
    _remote_model = remote_model class_name

  end

  def import_data
    _class_names = model_names || IMPORT_MODELS
    _class_names.each do |class_name|
      import_table class_name
    end
  end

  def import_table(class_name)
    _local_model = local_model class_name
    _remote_model = remote_model class_name
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
    @remote_dep_code ||= params[:remote_dep_code]
  end

  def action
    @action ||= params[:action].to_sym
  end

  def model_names
    @model_names ||= params[:model_names]
  end

  def import_log
    @import_log ||= []
  end

end