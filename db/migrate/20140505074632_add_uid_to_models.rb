class AddUidToModels < ActiveRecord::Migration
  class Model < ActiveRecord::Base
    self.abstract_class = true
  end

  JOIN_TABLES = ENV['JOIN_TABLES'].split

  COMMON_TABLES = ENV['COMMON_MODELS'].split.map(&:tableize) + JOIN_TABLES

  IMPORT_TABLES = ENV['IMPORT_MODELS'].split.map(&:tableize)

  COMMON_FOREIGN_KEYS = COMMON_TABLES.map(&:foreign_key)

  UNIQUE_FOREIGN_KEYS = IMPORT_TABLES.map(&:foreign_key)

  FOREIGN_KEYS = COMMON_FOREIGN_KEYS + UNIQUE_FOREIGN_KEYS + %w[performer_id]

  def up
    if (department_code = ENV['DEPARTMENT_CODE']).present?
      (COMMON_TABLES + IMPORT_TABLES).each do |table|
        # if column_exists? table, :id
        has_id = false
        unless table.in? JOIN_TABLES
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
    (COMMON_TABLES + IMPORT_TABLES).each do |table|
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
