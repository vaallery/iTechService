class ClientCategoriesController < ApplicationController
  authorize_resource

  def index
    @client_categories = ClientCategory.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @client_category = ClientCategory.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @client_category = ClientCategory.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @client_category = ClientCategory.new(params[:client_category])
    respond_to do |format|
      if @client_category.save
        format.html { redirect_to client_categories_path, notice: 'Client category was successfully created.' }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @client_category = ClientCategory.find(params[:id])
    respond_to do |format|
      if @client_category.update_attributes(params[:client_category])
        format.html { redirect_to client_categories_path, notice: 'Client category was successfully updated.' }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @client_category = ClientCategory.find(params[:id])
    @client_category.destroy
    respond_to do |format|
      format.html { redirect_to client_categories_url }
    end
  end
end
