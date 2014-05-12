class Sync::RemoteBase < ActiveRecord::Base

  # attr_accessor :connection_name
  # attr_accessor :table_name

  self.abstract_class = true
  establish_connection 'remote_kh'
  # self.table_name = ''

  # def connection
  #   self.establish_connection connection_name
  # end

end