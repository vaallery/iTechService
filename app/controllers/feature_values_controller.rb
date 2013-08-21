class FeatureValuesController < ApplicationController
  # GET /feature_values
  # GET /feature_values.json
  def index
    @feature_values = FeatureValue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feature_values }
    end
  end

  # GET /feature_values/1
  # GET /feature_values/1.json
  def show
    @feature_value = FeatureValue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feature_value }
    end
  end

  # GET /feature_values/new
  # GET /feature_values/new.json
  def new
    @feature_value = FeatureValue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feature_value }
    end
  end

  # GET /feature_values/1/edit
  def edit
    @feature_value = FeatureValue.find(params[:id])
  end

  # POST /feature_values
  # POST /feature_values.json
  def create
    @feature_value = FeatureValue.new(params[:feature_value])

    respond_to do |format|
      if @feature_value.save
        format.html { redirect_to @feature_value, notice: 'Feature value was successfully created.' }
        format.json { render json: @feature_value, status: :created, location: @feature_value }
      else
        format.html { render action: "new" }
        format.json { render json: @feature_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feature_values/1
  # PUT /feature_values/1.json
  def update
    @feature_value = FeatureValue.find(params[:id])

    respond_to do |format|
      if @feature_value.update_attributes(params[:feature_value])
        format.html { redirect_to @feature_value, notice: 'Feature value was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feature_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feature_values/1
  # DELETE /feature_values/1.json
  def destroy
    @feature_value = FeatureValue.find(params[:id])
    @feature_value.destroy

    respond_to do |format|
      format.html { redirect_to feature_values_url }
      format.json { head :no_content }
    end
  end
end
