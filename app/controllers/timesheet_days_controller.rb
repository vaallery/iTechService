class TimesheetDaysController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :new]

  def index
    @users = User.ordered
    @timesheet_date = (params[:date].present? ? params[:date].to_date : Date.current).beginning_of_month

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @timesheet_days }
    end
  end

  def new
    @timesheet_day = TimesheetDay.new params[:timesheet_day]

    respond_to do |format|
      format.js { render 'show_form' }
      format.json { render json: @timesheet_day }
    end
  end

  def edit
    @timesheet_day = TimesheetDay.find(params[:id])

    respond_to do |format|
      format.js { render 'show_form' }
    end
  end

  def create
    @data = {user: @timesheet_day.user, date: @timesheet_day.date}
    respond_to do |format|
      if @timesheet_day.save
        format.js { render 'update_cell' }
        format.json { render json: @timesheet_day, status: :created, location: @timesheet_day }
      else
        format.js { render 'show_form' }
        format.json { render json: @timesheet_day.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @data = {user: @timesheet_day.user, date: @timesheet_day.date}
    respond_to do |format|
      if @timesheet_day.update_attributes(params[:timesheet_day])
        format.js { render 'update_cell' }
        format.json { head :no_content }
      else
        format.js { render 'show_form' }
        format.json { render json: @timesheet_day.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @data = { user: @timesheet_day.user, date: @timesheet_day.date }
    @timesheet_day.destroy

    respond_to do |format|
      format.js { render 'update_cell' }
      format.json { head :no_content }
    end
  end

end
