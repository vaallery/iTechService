class AddUidToModels < ActiveRecord::Migration
  class Model < ActiveRecord::Base
    self.abstract_class = true
  end

  def up
    department_code = ENV['DEPARTMENT_CODE']
    if department_code.present?
      tables = self.tables - ['schema_migrations', 'ckeditor_assets', 'delayed_jobs', 'wiki_page_attachments', 'wiki_page_versions', 'wiki_pages']
      tables.each do |table|
        add_column table, :uid, :string if column_exists? table, :id
        Model.table_name = table
        Model.reset_column_information
        foreign_keys = Model.columns.keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
        foreign_keys.each do |fk|
          change_column table, fk, :string
        end
        is_uid_present = column_exists?(table, :uid) and column_exists?(table, :id)
        Model.reset_column_information
        Model.unscoped.all.each do |r|
          r.update_column :uid, "#{department_code}#{r.id}" if is_uid_present
          foreign_keys.each do |fk|
            fid = r.send(fk)
            r.update_column fk, "#{department_code}#{fid}" if fid.present?
          end
        end
      end
    end
  end

  def down
    department_code = ENV['DEPARTMENT_CODE']
    if department_code.present?
      tables = self.tables - ['schema_migrations', 'ckeditor_assets', 'delayed_jobs', 'wiki_page_attachments', 'wiki_page_versions', 'wiki_pages']
      tables.each do |table|
        remove_column table, :uid if column_exists? table, :uid
        Model.table_name = table
        Model.reset_column_information
        foreign_keys = Model.columns.keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
        Model.reset_column_information
        Model.unscoped.all.each do |r|
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
end
