class FetchSalesFile
  def call
    Mail.defaults do
      retriever_method :imap,
                       address: ENV['SALES_EMAIL_HOST'],
                       port: 993,
                       user_name: ENV['SALES_EMAIL_LOGIN'],
                       password: ENV['SALES_EMAIL_PASSWORD'],
                       enable_ssl: true
    end

    # email = Mail.find(what: :last, count: 1, keys: ['SUBJECT', 'Продажи 1С'])
    email = Mail.last
    return false, 'Письмо не найдено' if email.nil?

    attachment = email.attachments.first
    return false, 'Файл не найден' if attachment.nil?

    filename = attachment.filename
    filepath = Rails.root.join('tmp', filename)
    begin
      File.open(filepath, 'wb', 0644) { |f| f.write attachment.decoded }
      return true, filepath.to_s
    rescue => e
      return false, "Невозможно сохранить файл #{filepath} - #{e.message}"
    end
  end

  def self.call
    new.call
  end

  private

  def host
    ENV['SALES_EMAIL_HOST']
  end

  def login
    ENV['SALES_EMAIL_LOGIN']
  end

  def password
    ENV['SALES_EMAIL_PASSWORD']
  end
end
