class QuickTasksController < ApplicationController
  authorize_resource

  def index
    @quick_tasks = QuickTask.name_asc

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quick_tasks }
    end
  end

  def new
    @quick_task = QuickTask.new

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @quick_task }
    end
  end

  def edit
    @quick_task = QuickTask.find(params[:id])

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @quick_task }
    end
  end

  def create
    @quick_task = QuickTask.new(params[:quick_task])

    respond_to do |format|
      if @quick_task.save
        format.html { redirect_to quick_tasks_path, notice: t('quick_tasks.created') }
        format.json { render json: @quick_task, status: :created, location: @quick_task }
      else
        format.html { render 'form' }
        format.json { render json: @quick_task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @quick_task = QuickTask.find(params[:id])

    respond_to do |format|
      if @quick_task.update_attributes(params[:quick_task])
        format.html { redirect_to quick_tasks_path, notice: t('quick_tasks.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @quick_task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quick_task = QuickTask.find(params[:id])
    @quick_task.destroy

    respond_to do |format|
      format.html { redirect_to quick_tasks_url }
      format.json { head :no_content }
    end
  end
end
