module Sync

  class DataSyncJob < Struct.new(:params)

    TIME_FORMAT = '%Y.%m.%d %H:%M:%S'
    MODES = %w[clean update]
    COMMON_MODELS = %w[Bank CaseColor CashDrawer ClientCategory Department DeviceType ProductCategory ProductGroup Product Item FeatureType Feature Location PaymentType PriceType ProductPrice RepairGroup SparePart Store StoreItem StoreProduct Task User]
    IMPORT_MODELS = %w[ClientCharacteristic GiftCertificate CashShift CashOperation Sale SaleItem Payment Device DeviceTask RepairTask StoreItem Client]

    def name
      "Data sync {#{params.inspect}}"
    end

    def perform
      log << ['info', "Synchronization started at #{DateTime.current.strftime(TIME_FORMAT)} with params: #{params.inspect}"]
      if Department.current.present? and Department.current.is_main?
        if remote_dep_code.present?
          if ActiveRecord::Base.configurations["remote_#{remote_dep_code}"].present?
            if action.present?
              transfer_data action.to_sym
            else
              sync_data
            end
          else
            log << ['error', "!!! Database configuration is not defined (remote_#{remote_dep_code})"]
          end
        else
          log << ['error', '!!! Remote department code is not defined']
        end
      else
        log << ['error', '!!! Current department is not main']
      end
      log
    end

    def log
      @log ||= []
    end

    private

    # reflect_on_all_associations

    def sync_data

    end

    def transfer_data(direction)
      _model_names = model_names || (direction == :import ? IMPORT_MODELS : COMMON_MODELS)
      _model_names.each do |model_name|
        transfer_table model_name, direction unless model_name.blank?
      end
    end

    def transfer_table(model_name, direction)
      if direction.in? [:import, :export] and model_name.in? (COMMON_MODELS | IMPORT_MODELS)
        log << ['info', "#{direction.to_s.humanize}ing #{model_name}"]
        @direction = direction
        @current_model = model_name.constantize
        dst_model.connection.execute "TRUNCATE #{@current_model.table_name} RESTART IDENTITY" if mode == 'clean'
        src_model.find_each do |src_rec|
          src_attributes = src_rec.attributes.except 'id', 'created_at', 'updated_at'
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
                if dst_rec.update_attributes src_attributes
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

    def src_model
      @direction == :import ? remote_model : local_model
    end

    def dst_model
      @direction == :export ? remote_model : local_model
    end

    def local_model#(model_name)
      @current_model.establish_connection Rails.env
      @current_model
    end

    def remote_model#(model_name)
      # model_class = RemoteBase.new connection_name: "remote_#{remote_dep_code}", table_name: model_name.tableize
      # model_class = model_name.constantize
      @current_model.establish_connection "remote_#{remote_dep_code}"
      @current_model
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

  end

end