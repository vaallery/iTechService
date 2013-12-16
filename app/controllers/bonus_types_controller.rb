class BonusTypesController < ApplicationController
  authorize_resource

  def index
    @bonus_types = BonusType.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @bonus_type = BonusType.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @bonus_type = BonusType.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @bonus_type = BonusType.new(params[:bonus_type])
    respond_to do |format|
      if @bonus_type.save
        format.html { redirect_to bonus_types_path, notice: t('bonus_types.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @bonus_type = BonusType.find(params[:id])
    respond_to do |format|
      if @bonus_type.update_attributes(params[:bonus_type])
        format.html { redirect_to bonus_types_path, notice: t('bonus_types.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @bonus_type = BonusType.find(params[:id])
    @bonus_type.destroy
    respond_to do |format|
      format.html { redirect_to bonus_types_url }
    end
  end
end
