class DepartmentsController < ApplicationController
  authorize_resource

  def index
    @departments = Department.scoped
    respond_to do |format|
      format.html
    end
  end

  def show
    @department = Department.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @department = Department.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @department = Department.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @department = Department.new(params[:department])
    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: t('departments.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @department = Department.find(params[:id])
    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to @department, notice: t('departments.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url }
    end
  end
end
