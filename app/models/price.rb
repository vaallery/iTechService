class Price < ActiveRecord::Base
  belongs_to :department

  mount_uploader :file, PriceUploader

  attr_accessible :file, :remove_file, :remote_file_url, :department_id

  after_initialize do
    self.department_id ||= Department.current.id
  end

  def file_name
    file&.file&.original_filename
  end
end
