class InfosController < ApplicationController
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    if can? :manage, Info
      @infos = Info.newest
      unless sort_column.blank? and sort_direction.blank?
        @infos = @infos.reorder(sort_column + ' ' + sort_direction)
      end
      @infos = @infos.page(params[:page])
    else
      @infos = Info.available_for(current_user).grouped_by_date
    end

    respond_to do |format|
      format.html
      format.json { render json: @infos }
      format.js { render 'shared/index' }
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
