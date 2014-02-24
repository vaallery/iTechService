class QuickOrdersController < ApplicationController
  authorize_resource

  def index
    @quick_orders = QuickOrder.in_month.undone.created_desc.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.js { render 'shared/index' }
    end
  end

  def show
    @quick_order = QuickOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        filename = "quick_order_#{@quick_order.number}.pdf"
        pdf = QuickOrderPdf.new @quick_order, view_context
        print_ticket(pdf, filename) if params[:print]
        send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def new
    @quick_order = QuickOrder.new

    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @quick_order = QuickOrder.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @quick_order = QuickOrder.new(params[:quick_order])

    respond_to do |format|
      if @quick_order.save
        format.html { redirect_to quick_orders_path, notice: t('quick_orders.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @quick_order = QuickOrder.find(params[:id])

    respond_to do |format|
      if @quick_order.update_attributes(params[:quick_order])
        format.html { redirect_to quick_orders_path, notice: t('quick_orders.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def set_done
    @quick_order = QuickOrder.find(params[:id])

    respond_to do |format|
      if @quick_order.set_done
        format.html { redirect_to quick_orders_path, notice: t('quick_orders.updated') }
        format.js
      else
        format.html { render 'form' }
        format.js { render nothing: true }
      end
    end
  end

  def destroy
    @quick_order = QuickOrder.find(params[:id])
    @quick_order.destroy

    respond_to do |format|
      format.html { redirect_to quick_orders_url }
    end
  end

  private

  def print_ticket(pdf, filename)
    filepath = "#{Rails.root.to_s}/tmp/pdf/#{filename}"
    pdf.render_file filepath
    system 'lp', filepath
  end

end
