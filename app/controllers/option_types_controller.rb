class OptionTypesController < ApplicationController
  before_action :set_option_type, only: %i[edit update destroy]

  def index
    authorize OptionType
    @option_types = OptionType.all

    respond_to do |format|
      format.html
    end
  end

  def new
    @option_type = authorize OptionType.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @option_type = authorize OptionType.new(option_type_params)
    respond_to do |format|
      if @option_type.save
        format.html { redirect_to option_types_path, notice: t('option_types.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    respond_to do |format|
      if @option_type.update(option_type_params)
        format.html { redirect_to option_types_path, notice: t('option_types.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @option_type.destroy
    respond_to do |format|
      format.html { redirect_to option_types_path }
    end
  end

  private

  def set_option_type
    @option_type = find_record OptionType
  end

  def option_type_params
    params.require(:option_type).permit(:name, :code, :position, option_values_attributes: %i[id name code position])
  end
end
