class TradeInDevicesController < ApplicationController
  respond_to :html

  def index
    respond_to do |format|
      run TradeInDevice::Index do
        format.html { return render_cell TradeInDevice::Cell::Index }
        format.js { return }
      end
      format.any(:html, :js) { failed }
    end
  end

  def show
    run TradeInDevice::Show do
      return render_cell TradeInDevice::Cell::Show
    end
    failed
  end

  def print
    run TradeInDevice::Print do |result|
      pdf = result['pdf']
      return send_data pdf.render, filename: pdf.filename, type: 'application/pdf', disposition: 'inline'
    end
    failed
  end

  def new
    run TradeInDevice::Create::Present do
      return render_form
    end
    failed
  end

  def create
    run TradeInDevice::Create do
      # TradeInDevice::Print.({id: @model.id}, 'current_user' => current_user)
      # return redirect_to new_trade_in_device_path, notice: operation_message
      return redirect_to print_trade_in_device_path(@model.id), notice: operation_message
    end
    flash.now.alert = operation_message
    render_form
  end

  def edit
    run TradeInDevice::Update::Present do
      return render_form
    end
    failed
  end

  def update
    run TradeInDevice::Update do
      return redirect_to_index notice: operation_message
    end
    render_form
  end

  def destroy
    run TradeInDevice::Destroy do
      return redirect_to trade_in_devices_url, notice: operation_message
    end
    failed
  end

  private

  def render_form
    render_cell TradeInDevice::Cell::Form
  end
end
