class SalesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @sales = Sale.search(params).order('sold_at desc').page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @sales }
      format.js { render 'shared/index' }
    end
  end

  def show
    @sale = Sale.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @sale }
    end
  end

end
