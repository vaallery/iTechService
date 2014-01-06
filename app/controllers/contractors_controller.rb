class ContractorsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @contractors }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @contractor }
    end
  end

  def new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @contractor }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @contractor }
    end
  end

  def create
    respond_to do |format|
      if @contractor.save
        format.html { redirect_to contractors_path, notice: t('contractors.created') }
        format.json { render json: @contractor, status: :created, location: @contractor }
      else
        format.html { render 'form' }
        format.json { render json: @contractor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contractor.update_attributes(params[:contractor])
        format.html { redirect_to contractors_path, notice: t('contractors.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @contractor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contractor.destroy

    respond_to do |format|
      format.html { redirect_to contractors_url }
      format.json { head :no_content }
    end
  end
end
