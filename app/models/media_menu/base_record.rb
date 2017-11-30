module MediaMenu
  class BaseRecord < ActiveRecord::Base
    self.abstract_class = true
    establish_connection adapter: 'sqlite3', database: Setting.meda_menu_database unless Setting.meda_menu_database.nil?

    def database_folder
      @database_folder ||= File.dirname Setting.meda_menu_database
    end
  end
end