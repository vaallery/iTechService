module MediaMenu
  class Item < BaseRecord
    self.table_name = 'ZMEDIAINFORMATION'
    has_and_belongs_to_many :tags, join_table: 'Z_1TAGS',
                            foreign_key: 'Z_1TAGGEDMEDIAINFOS', association_foreign_key: 'Z_9TAGS'
    scope :movies, -> { where Z_ENT: 6 }

    def self.search(term)
      items = all
      unless term.blank?
        term.chomp.split(/\s+/).each do |word|
          # items = items.where('LOWER(ZMEDIAINFORMATION.ZNAME) LIKE :s', s: "%#{word.mb_chars.downcase.to_s}%")
          items = items.where('ZMEDIAINFORMATION.ZNAME LIKE :s', s: "%#{word}%")
        end
      end
      items
    end

    def self.sort_by(attribute, direction = :asc)
      db_attr = {
        name: 'ZNAME',
        year: 'ZYEAR',
        genre: 'ZGENRE'
      }[attribute.to_sym]
      order(db_attr => direction)
    end

    def db_id; self[:ZDATABASEID] end

    def name; self[:ZNAME] end

    def size; self[:ZSIZE] end

    def year; self[:ZYEAR] end

    def artist; self[:ZAUTHOR] end

    def description; self[:ZCOMMENT] end

    def genre; self[:ZGENRE] end

    def duration; self[:ZTOTALTIME1] end

    def image_file
      # File.join database_folder, 'images', "#{db_id}.png"
      "#{db_id}.png"
    end

    def category

    end
  end
end