class ReportsController < ApplicationController
  authorize_resource

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