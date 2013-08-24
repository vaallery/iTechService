class FeatureTypesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @feature_types }
    end
  end

  def new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @feature_type }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    respond_to do |format|
      if @feature_type.save
        format.html { redirect_to feature_types_path, notice: 'Feature type was successfully created.' }
        format.json { render json: @feature_type, status: :created, location: @feature_type }
      else
        format.html { render 'form' }
        format.json { render json: @feature_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feature_type.update_attributes(params[:feature_type])
        format.html { redirect_to feature_types_path, notice: 'Feature type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @feature_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature_type.destroy

    respond_to do |format|
      format.html { redirect_to feature_types_url }
      format.json { head :no_content }
    end
  end
end
