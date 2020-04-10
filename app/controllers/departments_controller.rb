class DepartmentsController < ApplicationController
  def index
    authorize Department
    @departments = Department.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @department = find_record Department
    respond_to do |format|
      format.html
    end
  end

  def new
    @department = authorize Department.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @department = find_record Department
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @department = authorize Department.new(params[:department])
    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: t('departments.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @department = find_record Department
    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to @department, notice: t('departments.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @department = find_record Department
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url }
    end
  end
end
