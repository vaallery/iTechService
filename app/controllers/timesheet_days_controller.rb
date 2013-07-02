class TimesheetDaysController < ApplicationController


  def index
    @timesheet_days = TimesheetDay.all

    respond_to do |format|
      format.html
      format.json { render json: @timesheet_days }
    end
  end

  def show
    @timesheet_day = TimesheetDay.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @timesheet_day }
    end
  end

  def new
    @timesheet_day = TimesheetDay.new

    respond_to do |format|
      format.html
      format.json { render json: @timesheet_day }
    end
  end

  def edit
    @timesheet_day = TimesheetDay.find(params[:id])
  end

  def create
    @timesheet_day = TimesheetDay.new(params[:timesheet_day])

    respond_to do |format|
      if @timesheet_day.save
        format.html { redirect_to @timesheet_day, notice: 'Timesheet day was successfully created.' }
        format.json { render json: @timesheet_day, status: :created, location: @timesheet_day }
      else
        format.html { render action: "new" }
        format.json { render json: @timesheet_day.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @timesheet_day = TimesheetDay.find(params[:id])

    respond_to do |format|
      if @timesheet_day.update_attributes(params[:timesheet_day])
        format.html { redirect_to @timesheet_day, notice: 'Timesheet day was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timesheet_day.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @timesheet_day = TimesheetDay.find(params[:id])
    @timesheet_day.destroy

    respond_to do |format|
      format.html { redirect_to timesheet_days_url }
      format.json { head :no_content }
    end
  end
end
