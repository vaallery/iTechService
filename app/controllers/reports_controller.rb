class ReportsController < ApplicationController

  #def index
  #  @start_date = (params[:start_date] || 1.day.ago).to_datetime.beginning_of_day
  #  @end_date = (params[:end_date] || 1.day.ago).to_datetime.end_of_day
    #period = [@start_date..@end_date]
    #report_name = params[:report]

    #if Report.respond_to? report_name
    #  case report_name
    #    when 'device_types_report' then @report = Report.device_types_report period, params[:device_type]
    #    #when 'users_report' then @report = Report.users_report period
    #    #when 'tasks_report' then @report = Report.done_tasks_report period
    #    #when 'clients_report' then @report = Report.clients_report period
    #    #when 'tasks_durations_report' then @report = Report.tasks_duration_report period
    #    #when 'done_orders_report' then @report = Report.done_orders_report period
    #    #when 'devices_movements_report' then @report = Report.devices_movements_report period
    #    #when 'payments_report' then @report = Report.payments_report period
    #    #when 'sales_report' then @report = Report.sales_report period
    #    when 'salary_report' then can?(:manage, Salary) ? @report = Report.salary_report : render(nothing: true)
    #    when 'few_remnants_goods' then @report = Report.few_remnants_report :goods
    #    when 'few_remnants_spare_parts' then @report = Report.few_remnants_report :spare_parts
    #    #when 'supply_report' then @report = Report.supply_report period
    #    #when 'repair_jobs' then @report = Report.repair_jobs_report period
    #    else Report.send report_name.to_sym, period
    #  end
    #else
    #  render nothing: true
    #end
  #end

  def index
    @report = Report.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def new
    @report = Report.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @report = Report.new params[:report]
    respond_to do |format|
      if @report.save
        format.html { render 'form' }
        format.js
      else
        format.html { render 'form' }
        format.js
      end
    end
  end

end