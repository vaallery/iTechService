module Sync
  class RemoteBase < ActiveRecord::Base

    # cattr_accessor :connection_name
    # cattr_accessor :table_name

    self.abstract_class = true
    # establish_connection connection_name
    # self.table_name = ''

  end
end