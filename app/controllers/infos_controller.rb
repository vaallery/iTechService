class InfosController < ApplicationController
  helper_method :sort_column, :sort_direction
  authorize_resource

  def index
    if params[:important].present?
      if (@info = Info.actual.important.first).present?
        render @info, layout: false
      else
        render nothing: true
      end
    elsif params[:personal].present?
      if (@infos = Info.actual.addressed_to(current_user)).present?
        render @infos, layout: false
      else
        render nothing: true
      end
    else
      @infos = params[:archive].present? ? Info.archived.newest : Info.actual.newest
      if can? :manage, Info
        @infos = @infos.newest
        unless sort_column.blank? and sort_direction.blank?
          @infos = @infos.reorder(sort_column + ' ' + sort_direction)
        end
      else
        @infos = @infos.newest.available_for(current_user)
      end
      @infos = @infos.page(params[:page])

      respond_to do |format|
        format.html
        format.json { render json: @infos }
        format.js { render 'shared/index' }
      end
    end
  end

  def show
    @info = Info.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @info }
    end
  end

  def new
    @info = Info.new

    respond_to do |format|
      format.html
      format.json { render json: @info }
    end
  end

  def edit
    @info = Info.find(params[:id])
  end

  def create
    @info = Info.new(params[:info])

    respond_to do |format|
      if @info.save
        format.html { redirect_to @info, notice: t('infos.created') }
        format.json { render json: @info, status: :created, location: @info }
      else
        format.html { render action: "new" }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @info = Info.find(params[:id])

    respond_to do |format|
      if @info.update_attributes(params[:info])
        format.html { redirect_to @info, notice: t('infos.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @info = Info.find(params[:id])
    @info.destroy

    respond_to do |format|
      format.html { redirect_to infos_url }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
    Info.column_names.include?(params[:sort]) ? params[:sort] : ''
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

end
