class FaultsController < ApplicationController
  authorize_resource

  def index
    @faults = Fault.where(causer_id: params[:user_id]).ordered
    respond_to do |format|
      format.js
    end
  end

  def new
    form Fault::Create
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def create
    @user = User.find params[:user_id]
    respond_to do |format|
      run Fault::Create do |_|
        format.js { render 'shared/close_modal_form' }
      end
      format.js { render 'shared/show_modal_form' }
    end
  end
end