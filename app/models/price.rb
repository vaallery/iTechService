class Price < ActiveRecord::Base
  mount_uploader :file, PriceUploader

  # default_scope where('prices.department_id = ?', Department.current.id)

  belongs_to :department

  attr_accessible :file, :remove_file, :remote_file_url, :department_id

  after_initialize do
    department_id ||= Department.current.id
  end

  def file_name
    file.file.original_filename
  end

end
