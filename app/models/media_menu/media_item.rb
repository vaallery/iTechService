module MediaMenu
  class MediaItem < BaseRecord
    self.table_name = 'ZMEDIAINFORMATION'
    has_and_belongs_to_many :tags, class_name: MediaTag.name, join_table: 'Z_1TAGS',
                            foreign_key: 'Z_1TAGGEDMEDIAINFOS', association_foreign_key: 'Z_9TAGS'
    default_scope -> { movies }
    scope :movies, -> { where Z_ENT: 6 }


    def name; self[:ZNAME] end

    def size; self[:ZSIZE] end

    def year; self[:ZYEAR] end

    def artist; self[:ZAUTHOR] end

    def description; self[:ZCOMMENT] end

    def genre; self[:ZGENRE] end

    def duration; self[:ZTOTALTIME1] end

    def image_file
      File.join database_folder, 'images', self[:ZDATABASEID]
    end
  end
end