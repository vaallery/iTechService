# encoding: utf-8

class Location < ApplicationRecord
  CODES = %w[
    archive
    bar
    content
    done
    laser
    repair
    repairmac
    repair_notebooks
    special
    warranty
  ].freeze

  scope :ordered, -> { order('position asc') }
  scope :in_city, ->(city) { where department_id: Department.in_city(city) }
  scope :in_department, ->(department) { where department_id: department }
  scope :for_schedule, -> { where(schedule: true) }
  scope :visible, -> { where hidden: [false, nil] }
  scope :archive, -> { where code: 'archive' }
  scope :bar, -> { where code: 'bar' }
  scope :content, -> { where code: 'content' }
  scope :done, -> { where code: 'done' }
  scope :repair, -> { where code: 'repair' }
  scope :repair_notebooks, -> { where code: 'repair_notebooks' }
  scope :warranty, -> { where code: 'warranty' }
  scope :code_start_with, ->(code) { where('code LIKE ?', "#{code}%") }
  scope :short_term, -> { where storage_term: 3 }
  scope :long_term, -> { where storage_term: 12 }
  scope :termless, -> { where storage_term: nil }

  scope :search, ->(params) do
    where(department_id: params[:department_id]) if params.key?(:department_id)
  end

  belongs_to :department, required: true, inverse_of: :locations
  has_many :users
  delegate :name, to: :department, prefix: true, allow_nil: true
  delegate :city, to: :department, allow_nil: true

  attr_accessible :name, :schedule, :position, :code, :department_id, :hidden, :storage_term
  validates_presence_of :name

  def full_name
    path.all.map { |l| l.name }.join(' / ')
  end

  def self.archive_ids
    Location.archive.pluck(:id)
  end

  def self.allowed_for(user, service_job)
    if user.admin?
      visible
    else
      department = (service_job.present? && service_job.department.present?) ? service_job.department : Department.current
      visible.where(department_id: department.id)
    end
  end

  def is_done?
    code == 'done'
  end

  def is_archive?
    code == 'archive'
  end

  def is_repair?
    code == 'repair'
  end

  def is_warranty?
    code == 'warranty'
  end

  def is_repair_notebooks?
    code == 'repair_notebooks'
  end

  def is_any_repair?
    code.to_s.start_with?('repair')
  end

  def is_special?
    code == 'special'
  end
end
