class KarmasController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :new

  def new
    @karma = Karma.new params[:karma]
    respond_to do |format|
      format.js { render 'show_form' }
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'show_form' }
    end
  end

  def create
    respond_to do |format|
      if @karma.save
        format.js
      else
        format.js { render 'show_form' }
      end
    end
  end

  def update
    respond_to do |format|
      if @karma.update_attributes params[:karma]
        format.js
      else
        format.js { render 'show_form' }
      end
    end
  end

  def destroy
    @karma.destroy
    respond_to do |format|
      format.js
    end
  end
end
