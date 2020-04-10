class TradeInDevicesController < ApplicationController
  skip_after_action :verify_authorized
  respond_to :html

  def index
    respond_to do |format|
      run TradeInDevice::Index do |result|
        format.html { return render_cell TradeInDevice::Cell::Index, context: {policy: result['policy.default']} }
        format.js do
          content = cell(TradeInDevice::Cell::Table, result['model'], context: {policy: result['policy.default']}).()
          render 'index', locals: {content: content}
        end
      end
      format.any(:html, :js) { failed }
    end
  end

  def purgatory
    authorize TradeInDevice, :index_unconfirmed?
    trade_in_devices = TradeInDevice.unconfirmed
    the_policy = policy(TradeInDevice)

    respond_to do |format|
      format.html { render_cell(TradeInDevice::Cell::Purgatory, model: trade_in_devices, context: {policy: the_policy}) }
    end
  end

  def show
    run TradeInDevice::Show do
      return render_cell TradeInDevice::Cell::Show
    end
    failed
  end

  # TODO: make it via ajax
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
    permitted_params = if current_user.superadmin? || current_user.able_to?(:manage_trade_in)
                         params
                       else
                         params.merge(trade_in_device: params[:trade_in_device].slice(:apple_guarantee))
                       end

    run TradeInDevice::Update, permitted_params do
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
