module MediaMenu
  class Tag < BaseRecord
    self.table_name = 'ZMEDIATAG'
    has_and_belongs_to_many :items, join_table: 'Z_1TAGS',
                            foreign_key: 'Z_9TAGS', association_foreign_key: 'Z_1TAGGEDMEDIAINFOS'
  end
end