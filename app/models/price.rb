class Price < ActiveRecord::Base
  mount_uploader :file, PriceUploader
  attr_accessible :file, :remove_file, :remote_file_url

  def file_name
    file.file.original_filename
  end

end
