require 'sqlite3'
require 'vpim/vcard'
class ContactsExtractor

  attr_reader :db_file, :card_file

  def initialize(contacts_file)
    @db_file = contacts_file
    @card_file = File.open "#{Rails.root.to_s}/tmp/contacts.vcf", 'w'
  end

  def perform
    SQLite3::Database.new(db_file, results_as_hash: true) do |db|
      if table_exists? db, 'ZWACONTACT'
        db.execute('SELECT * FROM ZWACONTACT') do |row|
          card = Vpim::Vcard::Maker.make2 do |maker|
            id = row['Z_PK'].to_i
            firstname = row['ZFIRSTNAME']
            indexname = row['ZINDEXNAME']
            fullname = row['ZFULLNAME']
            puts "firstname: #{firstname}, fullname: #{fullname}"
            maker.add_name do |name|
              name.family = firstname unless firstname.nil?
              name.fullname = fullname unless fullname.nil?
            end
            db.execute("SELECT * FROM ZWAPHONE WHERE ZCONTACT = #{id}") do |phone_row|
              phone = phone_row['ZPHONE']
              puts "phone: #{phone}"
              maker.add_tel phone unless phone.nil?
            end
          end
          puts '-'*50
          card_file << card
        end
      end

      if table_exists? db, 'ZABCONTACT'
        db.execute('SELECT * FROM ZABCONTACT') do |row|
          card = Vpim::Vcard::Maker.make2 do |maker|
            id = row['Z_PK'].to_i
            family_name = row['ZMAINNAME']
            given_name = row['ZPREFIXNAME']
            puts "family_name: #{family_name}, given_name: #{given_name}"
            maker.add_name do |name|
              name.family = family_name unless family_name.nil?
              name.given = given_name unless given_name.nil?
            end
            if table_exists? db, 'ZABCONTACTNUMBER'
              phones_table_name = 'ZABCONTACTNUMBER'
              phone_column_name = 'ZPHONE'
            else
              phones_table_name = 'ZPHONENUMBERINDEX'
              phone_column_name = 'ZPHONENUM'
            end
            db.execute("SELECT * FROM #{phones_table_name} WHERE ZCONTACT = #{id}") do |phone_row|
              phone = phone_row[phone_column_name]
              puts "phone: #{phone}"
              maker.add_tel phone unless phone.nil?
            end
          end
          puts '-'*50
          card_file << card
        end
      end

    end
    card_file
  end

  private

  def table_exists?(db, table_name)
    db.execute("SELECT name FROM sqlite_master WHERE name ='#{table_name}' and type='table'").length > 0
  end
end
