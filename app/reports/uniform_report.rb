class UniformReport < BaseReport
  def call
    users = User.active.where.not(uniform_sex: nil)
    users = users.in_department(department) if department
    result[:uniforms] = users.order(:uniform_sex, :uniform_size).group(:uniform_sex, :uniform_size).count
    result
  end
end
