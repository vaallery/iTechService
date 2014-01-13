class SupplyReportsController < ApplicationController
  authorize_resource

  def index
    @supply_reports = SupplyReport.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @supply_report = SupplyReport.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @supply_report = SupplyReport.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @supply_report = SupplyReport.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @supply_report = SupplyReport.new(params[:supply_report])
    respond_to do |format|
      if @supply_report.save
        format.html { redirect_to @supply_report, notice: t('supply_reports.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @supply_report = SupplyReport.find(params[:id])
    respond_to do |format|
      if @supply_report.update_attributes(params[:supply_report])
        format.html { redirect_to @supply_report, notice: t('supply_reports.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @supply_report = SupplyReport.find(params[:id])
    @supply_report.destroy
    respond_to do |format|
      format.html { redirect_to supply_reports_url }
    end
  end
end
