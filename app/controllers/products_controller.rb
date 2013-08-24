class ProductsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @products = Product.search(params).page(params[:page])

    respond_to do |format|
      format.html
      format.js { render 'shared/index' }
      format.json { render json: @products }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end

  def new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @product }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to products_path, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

     def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
end
