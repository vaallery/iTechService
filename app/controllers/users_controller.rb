class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_infos, only: [:show, :profile]

  def index
    @users = User.search(params).id_asc.page(params[:page]).per(50)

    respond_to do |format|
      format.html
      format.json { render json: {users: @users.map { |u| u.short_name }} }
    end
  end

  def show
    @user = User.find(params[:id])
    @devices = @user.devices.unarchived

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('users.created') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render 'form' }
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
        format.js { render 'shared/close_modal_form' }
      else
        @salaries = @user.salaries
        @installments = @user.installments
        format.html { render 'form' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render 'shared/show_modal_form' }
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
    @devices = @user.devices.unarchived

    respond_to do |format|
      format.html { render 'show' }
      format.json { render json: @user }
    end
  end

  def duty_calendar
    @user = User.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def staff_duty_schedule
    @calendar_month = params[:date].blank? ? Date.current : params[:date].to_date
    respond_to do |format|
      format.js
    end
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
    @users = User.active.schedulable.id_asc
    @locations = Location.for_schedule
  end

  def add_to_job_schedule
    @msg = ''
    @user = User.find params[:id]
    @day = params[:day]
    @msg = 'User location not set' if (@location_id = @user.location.try(:id)).nil?
    @schedule_day = @user.schedule_days.find_by_day @day
  end

  def rating
    @users = User.active.staff.id_asc
  end

  def create_duty_day
    @duty_day = DutyDay.new params[:duty_day]
    @duty_day.save
    @day = @duty_day.day
    @kind = @duty_day.kind
    render 'update_duty_day'
  end

  def destroy_duty_day
    duty_day = DutyDay.find params[:duty_day_id]
    @day = duty_day.day
    @kind = duty_day.kind
    duty_day.destroy
    render 'update_duty_day'
  end

  def actions
    @user = User.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  def finance
    @user = User.find params[:id]
    @salaries = @user.salaries
    @installments = @user.installments

    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def bonuses
    @user = User.find params[:id]
    @bonuses = @user.bonuses
    respond_to do |format|
      format.js
    end
  end

  private

  def load_infos
    @infos = Info.actual.available_for(current_user).grouped_by_date.limit 20
  end

end
