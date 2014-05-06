class AddUidToModels < ActiveRecord::Migration
  class Model < ActiveRecord::Base
    self.abstract_class = true
  end

  def up
    department_code = ENV['DEPARTMENT_CODE']
    if department_code.present?
      (self.tables - ['schema_migrations', 'ckeditor_assets', 'delayed_jobs', 'wiki_page_attachments', 'wiki_page_versions', 'wiki_pages']).each do |table|
        add_column table, :uid, :string if column_exists? table, :id
        Model.table_name = table
        Model.reset_column_information
        foreign_keys = Model.columns.keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
        # foreign_keys = []
        # Model.reflect_on_all_associations(:belongs_to).each do |r|
        #   foreign_keys << (r.options[:foreign_key] || (r.name.to_s + '_id'))
        # end
        foreign_keys.each do |fk|
          change_column table, fk, :string
        end
        is_uid_present = column_exists?(table, :uid) and column_exists?(table, :id)
        Model.reset_column_information
        Model.find_each do |r|
          r.update_column :uid, "#{department_code}#{r.id}" if is_uid_present
          foreign_keys.each do |fk|
            r.update_column fk, "#{department_code}#{r.send(fk)}"
          end
        end
      end
    end
  end

  def down
    department_code = ENV['DEPARTMENT_CODE']
    if department_code.present?
      (self.tables - ['schema_migrations', 'ckeditor_assets', 'delayed_jobs', 'wiki_page_attachments', 'wiki_page_versions', 'wiki_pages']).each do |table|
        remove_column table, :uid
        Model.table_name = table
        foreign_keys = Model.columns.keep_if{|c|c.name.ends_with?('_id')}.map(&:name)
        Model.reset_column_information
        Model.find_each do |r|
          foreign_keys.each do |fk|
            r.update_column fk, "#{r.send(fk)}"[/\d/]
            change_column table, fk, :integer
          end
        end
      end
    end
  end
end
