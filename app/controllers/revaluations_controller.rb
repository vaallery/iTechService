class RevaluationsController < ApplicationController
  load_and_authorize_resource

  def index
    @revaluations = Revaluation.all

    respond_to do |format|
      format.html
      format.json { render json: @revaluations }
    end
  end

  def show
    @revaluation = Revaluation.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @revaluation }
    end
  end

  def new
    @revaluation = Revaluation.new

    respond_to do |format|
      format.html
      format.json { render json: @revaluation }
    end
  end

  def edit
    @revaluation = Revaluation.find(params[:id])
  end

  def create
    @revaluation = Revaluation.new(params[:revaluation])

    respond_to do |format|
      if @revaluation.save
        format.html { redirect_to @revaluation, notice: 'Revaluation was successfully created.' }
        format.json { render json: @revaluation, status: :created, location: @revaluation }
      else
        format.html { render action: "new" }
        format.json { render json: @revaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @revaluation = Revaluation.find(params[:id])

    respond_to do |format|
      if @revaluation.update_attributes(params[:revaluation])
        format.html { redirect_to @revaluation, notice: 'Revaluation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @revaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @revaluation = Revaluation.find(params[:id])
    @revaluation.destroy

    respond_to do |format|
      format.html { redirect_to revaluations_url }
      format.json { head :no_content }
    end
  end
end
