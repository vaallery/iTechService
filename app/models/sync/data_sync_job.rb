class Sync::DataSyncJob < Struct.new(:params)

  TIME_FORMAT = '%Y.%m.%d %H:%M:%S'
  MODES = %w[clean update]
  COMMON_MODELS = %w[Bank CaseColor CashDrawer ClientCategory Department DeviceType ProductCategory ProductGroup Product Item FeatureType Feature Location PaymentType PriceType ProductPrice ProductRelation RepairGroup SparePart Setting StolenPhone Store StoreItem StoreProduct Task User]
  IMPORT_MODELS = %w[ClientCharacteristic GiftCertificate CashShift CashOperation Sale SaleItem Payment Device DeviceTask RepairTask StoreItem Client]

  def name
    "Data sync {#{params.inspect}}"
  end

  def perform
    if Department.current.present? and Department.current.is_main?
      if remote_dep_code.present? and ActiveRecord::Base.configurations["#{Rails.env}_#{remote_dep_code}"].present?
        if action.present?
          transfer_data action
        else
          sync_data
        end
      end
    end
  end

  private

  # reflect_on_all_associations

  def sync_data

  end

  def transfer_data(direction)
    _model_names = model_names || (direction == :import ? IMPORT_MODELS : COMMON_MODELS)
    _model_names.each do |model_name|
      transfer_table model_name, direction
    end
  end

  def transfer_table(model_name, direction)
    if direction.in? [:import, :export]
      log << ['info', "#{direction.to_s.humanize}ing #{model_name}"]
      if direction == :import
        src_model = remote_model model_name
        dst_model = local_model model_name
      else
        src_model = local_model model_name
        dst_model = remote_model model_name
      end
      dst_model.connection.execute "TRUNCATE #{dst_model.table_name} RESTART IDENTITY" if mode == 'clean'
      src_model.find_each do |src_rec|
        src_attributes = src_rec.attributes.except 'id'
        case mode
          when 'clean'
            dst_rec = dst_model.new src_attributes
            if dst_rec.save
              log << ['success', "Created #{dst_rec.inspect}"]
            else
              log << ['error', "!!! Can not create #{src_attributes}. #{dst_rec.errors.full_messages.join('. ')}"]
            end
          when 'update'
            if (dst_rec = dst_model.where(id: src_rec.id).first).present?
              if update_columns dst_rec, src_attributes
                log << ['success', "Updated #{dst_rec.inspect}"]
              else
                log << ['error', "!!! Can not update #{dst_rec.inspect} with #{src_attributes}"]
              end
            end
          else
            dst_rec = dst_model.new src_attributes
            if dst_rec.save
              log << ['success', "Created #{dst_rec.inspect}"]
            else
              log << ['error', "!!! Can not create #{src_attributes}. #{dst_rec.errors.full_messages.join('. ')}"]
            end
        end
      end
    end
  end

  def update_columns(record, attributes)
    attributes.each do |k, v|
      record.update_column k, v
    end
  end

  def local_model(model_name)
    model_class = model_name.constantize
    model_class.establish_connection Rails.env
    model_class
  end

  def remote_model(model_name)
    model_class = model_name.constantize
    model_class.establish_connection "#{Rails.env}_#{remote_dep_code}"
    model_class
  end

  def remote_dep_code
    @remote_dep_code ||= params[:remote_dep_code]
  end

  def action
    @action ||= params[:action]
  end

  def mode
    @mode ||= params[:mode]
  end

  def model_names
    @model_names ||= params[:model_names]
  end

  def log
    @log ||= []
  end

end