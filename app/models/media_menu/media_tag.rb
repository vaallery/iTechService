module MediaMenu
  class MediaTag < BaseRecord
    self.table_name = 'ZMEDIATAG'
    has_and_belongs_to_many :items, class_name: MediaItem.name, join_table: 'Z_1TAGS',
                            foreign_key: 'Z_9TAGS', association_foreign_key: 'Z_1TAGGEDMEDIAINFOS'
  end
end