class AddUidToModels < ActiveRecord::Migration
  class Model < ActiveRecord::Base
    self.abstract_class = true
  end

  JOIN_TABLES = %w[feature_types_product_categories price_types_stores]
  # JOIN_TABLES = %w[announcements_users feature_types_product_categories price_types_stores quick_orders_quick_tasks]

  # MODELS = %w[Bank CaseColor CashDrawer ClientCategory Department DeviceType ProductCategory ProductGroup Product Item FeatureType Feature Location PaymentType PriceType ProductPrice RepairGroup SparePart Store StoreItem StoreProduct Task User ClientCharacteristic GiftCertificate CashShift CashOperation Sale SaleItem Payment Device DeviceTask RepairTask Client]

  TABLES = %w[banks case_colors cash_drawers client_categories departments device_types product_categories product_groups products items feature_types features locations payment_types price_types product_prices repair_groups spare_parts stores store_items store_products tasks users client_characteristics gift_certificates cash_shifts cash_operations sales sale_items payments devices device_tasks repair_tasks clients repair_parts repair_services]

  def up
    department_code = ENV['DEPARTMENT_CODE']
    if department_code.present?
      (TABLES + JOIN_TABLES).each do |table|
        if column_exists? table, :id
          add_column table, :uid, :string
          add_index table, :uid
        end
        Model.table_name = table
        Model.reset_column_information
        foreign_keys = columns(table).keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
        foreign_keys.each do |fk|
          change_column table, fk, :string
        end
        has_id = column_exists?(table, :uid) and column_exists?(table, :id)
        Model.reset_column_information
        Model.all.each do |r|
          r.update_column :uid, "#{department_code}#{r.id}" if has_id
          foreign_keys.each do |fk|
            fid = r.send(fk)
            r.update_column fk, "#{department_code}#{fid}" if fid.present?
          end
        end
      end
    end
  end

  # def up
  #   department_code = ENV['DEPARTMENT_CODE']
  #   if department_code.present?
  #     # tables = self.tables - SKIP_TABLES
  #     MODELS.each do |model_name|
  #       if (model = model_name.safe_constantize).present?
  #
  #         table = model.table_name
  #         has_id = false
  #         if model.respond_to? :id
  #           add_column table, :uid, :string
  #           add_index table, :uid
  #           has_id = true
  #           model.reset_column_information
  #         end
  #         foreign_keys = columns(table).keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
  #         # foreign_keys = model.columns.keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
  #         foreign_keys.each do |fk|
  #           change_column table, fk, :string
  #         end
  #         model.reset_column_information
  #         model.all.each do |r|
  #           r.update_column :uid, "#{department_code}#{r.id}" if has_id
  #           foreign_keys.each do |fk|
  #             fid = r.send(fk)
  #             r.update_column fk, "#{department_code}#{fid}" if fid.present?
  #           end
  #         end
  #       end
  #     end
  #     JOIN_TABLES.each do |table|
  #       Model.table_name = table
  #       Model.reset_column_information
  #       foreign_keys = columns(table).keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
  #       foreign_keys.each do |fk|
  #         change_column table, fk, :string
  #       end
  #       Model.reset_column_information
  #       Model.all.each do |r|
  #         foreign_keys.each do |fk|
  #           fid = r.send(fk)
  #           r.update_column fk, "#{department_code}#{fid}" if fid.present?
  #         end
  #       end
  #     end
  #   end
  # end

  def down
    department_code = ENV['DEPARTMENT_CODE']
    if department_code.present?
      (TABLES + JOIN_TABLES).each do |table|
        remove_column table, :uid if column_exists? table, :uid
        remove_index table, :uid if index_exists? table, :uid
        Model.table_name = table
        Model.reset_column_information
        foreign_keys = Model.columns.keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
        Model.reset_column_information
        Model.all.each do |r|
          foreign_keys.each do |fk|
            r.update_column fk, "#{r.send(fk)}"[/\d/]
          end
        end
        foreign_keys.each do |fk|
          change_column table, fk, "integer USING CAST(#{fk} AS integer)"
        end
      end
    end
  end

  # def down
  #   department_code = ENV['DEPARTMENT_CODE']
  #   if department_code.present?
  #     MODELS.each do |model_name|
  #       if (model = model_name.safe_constantize).present?
  #         table = model.table_name
  #         remove_column table, :uid if column_exists? table, :uid
  #         remove_index table, :uid  if index_exists? table, :uid
  #         model.reset_column_information
  #         foreign_keys = columns(table).keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
  #         model.all.each do |r|
  #           foreign_keys.each do |fk|
  #             r.update_column fk, "#{r.send(fk)}"[/\d/]
  #           end
  #         end
  #         foreign_keys.each do |fk|
  #           change_column table, fk, "integer USING CAST(#{fk} AS integer)"
  #         end
  #       end
  #     end
  #     JOIN_TABLES.each do |table|
  #       Model.table_name = table
  #       Model.reset_column_information
  #       foreign_keys = columns(table).keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
  #       Model.all.each do |r|
  #         foreign_keys.each do |fk|
  #           r.update_column fk, "#{r.send(fk)}"[/\d/]
  #         end
  #       end
  #       foreign_keys.each do |fk|
  #         change_column table, fk, "integer USING CAST(#{fk} AS integer)"
  #       end
  #     end
  #   end
  # end

end
