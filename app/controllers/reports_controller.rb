class ReportsController < ApplicationController
  authorize_resource

  def index
    respond_to do |format|
      format.html
    end
  end

  def new
    @report = build_report
    respond_to do |format|
      format.html
    end
  end

  def create
    @report = build_report
    @report.()
    respond_to do |format|
      format.html { render 'result' }
      format.js { render 'result' }
    end
  end

  private

  def build_report
    report_name = params[:report][:base_name]
    report_class_name = "#{report_name.camelize}Report"
    if defined? report_class_name
      klass = report_class_name.constantize
      klass.new params[:report]
    end
  end
end