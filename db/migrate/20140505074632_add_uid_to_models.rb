class AddUidToModels < ActiveRecord::Migration
  class Model < ActiveRecord::Base
    self.abstract_class = true
  end

  JOIN_TABLES = ENV['JOIN_TABLES'].split
  COMMON_TABLES = ENV['COMMON_MODELS'].split.map(&:tableize)
  IMPORT_TABLES = ENV['IMPORT_MODELS'].split.map(&:tableize)
  COMMON_FOREIGN_KEYS = ENV['COMMON_MODELS'].split.map(&:foreign_key)
  UNIQUE_FOREIGN_KEYS = ENV['IMPORT_MODELS'].split.map(&:foreign_key)
  FOREIGN_KEYS = COMMON_FOREIGN_KEYS + UNIQUE_FOREIGN_KEYS + %w[performer_id parent_id]
  # %w[bank_id|case_color_id|cash_drawer_id|client_category_id|department_id|product_category_id|product_group_id|product_id|item_id|feature_type_id|feature_id|payment_type_id|price_type_id|product_price_id|repair_group_id|repair_service_id|spare_part_id|store_id|store_item_id|store_product_id|cash_operation_id|cash_shift_id|client_id|client_characteristic_id|device_id|device_task_id|device_type_id|gift_certificate_id|location_id|payment_id|sale_id|sale_item_id|repair_task_id|repair_part_id|task_id|user_id|performer_id]

  def up
    if (department_code = ENV['DEPARTMENT_CODE']).present?
      (COMMON_TABLES + IMPORT_TABLES + JOIN_TABLES).each do |table|
        has_id = false
        unless table.in? JOIN_TABLES or column_exists? table, :uid
          add_column table, :uid, :string, unique: true
          add_index table, :uid
          has_id = true
        end
        Model.table_name = table
        Model.reset_column_information
        foreign_keys = columns(table).keep_if{|c|c.name.ends_with?('_id')}.map(&:name) & FOREIGN_KEYS
        foreign_keys.each do |fk|
          change_column table, fk, :string
        end
        Model.reset_column_information
        Model.all.each do |r|
          r.update_column :uid, "#{department_code if table.in?(IMPORT_TABLES)}#{r.id}" if has_id
          foreign_keys.each do |fk|
            fid = r.send(fk)
            r.update_column fk, "#{department_code if fk.in?(UNIQUE_FOREIGN_KEYS)}#{fid}" if fid.present?
          end
        end
      end
    end
  end

  def down
    (COMMON_TABLES + IMPORT_TABLES + JOIN_TABLES).each do |table|
      remove_column table, :uid if column_exists? table, :uid
      remove_index table, :uid if index_exists? table, :uid
      Model.table_name = table
      Model.reset_column_information
      foreign_keys = Model.columns.keep_if{|c|c.name.ends_with?('_id')}.map(&:name) & FOREIGN_KEYS
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
