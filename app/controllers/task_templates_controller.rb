class TaskTemplatesController < ApplicationController
  authorize_resource

  def index
    @task_templates = TaskTemplatesDecorator.decorate TaskTemplate.roots.ordered

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @task_template = TaskTemplate.new parent_id: params[:parent_id], position: params[:position]
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @task_template = TaskTemplate.new task_template_params
    respond_to do |format|
      if @task_template.save
        format.html { redirect_to (@task_template.parent.presence || task_templates_path), notice: t('task_templates.created') }
      end
      format.html
    end
  end

  def show
    @task_template = TaskTemplate.find(params[:id]).decorate
    @task_templates = TaskTemplatesDecorator.decorate @task_template.children.ordered
    respond_to do |format|
      format.html { render 'index' }
      format.js { render @task_template.has_children? ? 'index' : 'show' }
    end
  end

  def edit
    @task_template = TaskTemplate.find params[:id]
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def update
    @task_template = TaskTemplate.find params[:id]
    respond_to do |format|
      if @task_template.update task_template_params
        format.html { redirect_to (@task_template.parent || task_templates_path), notice: t('task_templates.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @task_template = TaskTemplate.find params[:id]
    @task_template.destroy
    respond_to do |format|
      format.html { redirect_to task_templates_path, notice: t('task_templates.destroyed') }
    end
  end

  private

  def task_template_params
    params.require(:task_template).permit(:content, :icon, :position, :parent_id)
  end
end