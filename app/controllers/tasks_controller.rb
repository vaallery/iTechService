class TasksController < ApplicationController
  load_and_authorize_resource

  def index
    @tasks = Task.scoped.page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @tasks }
    end
  end

  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: {cost: @task.cost}}
    end
  end

  def new
    @task = Task.new

    respond_to do |format|
      format.html
      format.json { render json: @task }
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t('tasks.created') }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to tasks_path, notice: t('tasks.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end
end
