# frozen_string_literal: true

class UsersJobsReport < BaseReport
  attr_accessor :user_id

  params %i[start_date end_date department_id user]

  def call
    users = User
    users = users.where(department_id: department.id) if department
    users = users.where(id: user_id) unless user_id.blank?
    users = users.all.to_a
    result[:users] = users.map do |user|
      item = {
        user_name: user.full_name,
        dates: {},
        counts: { fast: 0, long: 0, free: 0, total: 0 }
      }
      settings = {
        fast: :quick_orders,
        long: :service_jobs,
        free: :service_free_jobs
      }
      settings.each do |type, relation|
        user.send(relation).where(created_at: period).order(created_at: :asc).each do |job|
          add_job(item, job, type)
        end
      end
      item[:dates] = item[:dates].sort.to_h
      item[:dates].each do |date, jobs|
        item[:counts][:fast] += jobs[:fast].size
        item[:counts][:long] += jobs[:long].size
        item[:counts][:free] += jobs[:free].size
      end
      item[:counts][:total] = item[:counts].values.sum
      item[:counts][:total].zero? ? nil : item
    end.compact

    result
  end

  def add_job(item, job, type)
    date = job.created_at.strftime('%d.%m.%Y')
    time = job.created_at.strftime('%H:%M')
    item[:dates][date] ||= { fast: [], long: [], free: [] }
    item[:dates][date][type] << { time: time, item: job }
  end
end
