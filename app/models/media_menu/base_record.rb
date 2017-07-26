module MediaMenu
  class BaseRecord < ActiveRecord::Base
    self.abstract_class = true
    establish_connection adapter: 'sqlite3', database: '/Users/vova/Projects/Ruby/iTechService/Архив.zip Folder/Media_Menu_Server.storedata'
    # establish_connection adapter: 'sqlite3', database: Setting.meda_menu_database

    def database_folder
      @database_folder ||= File.dirname Setting.meda_menu_database
    end
  end
end