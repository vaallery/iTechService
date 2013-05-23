class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_infos, only: [:show, :profile]

  def index
    @users = User.order('id asc').page(params[:page]).per(50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('users.created') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: t('users.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def profile
    @user = current_user

    respond_to do |format|
      format.html { render 'show' }
      format.json { render json: @user }
    end
  end

  def duty_calendar
    @calendar_month = params[:date].blank? ? Date.current : params[:date].to_date

    respond_to do |format|
      format.js
    end
  end

  def staff_duty_schedule
    @calendar_month = params[:date].blank? ? Date.current : params[:date].to_date
  end

  def update_wish
    @user = User.find params[:id]

    respond_to do |format|
      if @user.update_attributes(wish: params[:user_wish])
        format.json { render json: {wish: @user.wish} }
      else
        format.json { render json: {error: 'error'}}
      end
    end
  end

  def schedule
    @users = User.schedulable
    @locations = Location.for_schedule
    @calendar_month = Date.current.beginning_of_month
  end

  def add_to_job_schedule
    @msg = ''
    @user = User.find params[:id]
    @day = params[:day]
    @msg = 'User location not set' if (@location_id = @user.location.try(:id)).nil?
    @schedule_day = @user.schedule_days.find_by_day @day
  end

  def rating
    @users = User.staff.order('id asc')
  end

  def create_duty_day
    @duty_day = DutyDay.new params[:duty_day]
    @duty_day.save
    @day = @duty_day.day
    render 'update_duty_day'
  end

  def destroy_duty_day
    duty_day = DutyDay.find params[:duty_day_id]
    @day = duty_day.day
    duty_day.destroy
    render 'update_duty_day'
  end

  def actions
    @user = User.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  private

  def load_infos
    @infos = Info.unarchived.available_for(current_user).grouped_by_date.limit 20
  end

end
