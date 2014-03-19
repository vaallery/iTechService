class SalesController < ApplicationController
  authorize_resource
  helper_method :sort_column, :sort_direction

  def index
    @sales = Sale.search(params).reorder(sort_column + ' ' + sort_direction).page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @sales }
      format.js { render (params[:form_name].present? ? 'shared/show_modal_form' : 'shared/index') }
    end
  end

  def show
    @sale = Sale.find params[:id]
    respond_to do |format|
      format.html
      format.json { render json: @sale }
      format.pdf do
        if can? :print_check, @sale
          pdf = SaleCheckPdf.new @sale, view_context, params[:copy].present?
          filename = "sale_check_#{@sale.id}.pdf"
          send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline'
        else
          render nothing: true
        end
      end
    end
  end

  def new
    @sale = Sale.new params[:sale]
    @top_salables = TopSalable.roots.ordered
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @sale = Sale.find params[:id]
    @top_salables = TopSalable.roots.ordered
    if can? :edit, @sale
      respond_to do |format|
        format.html { render 'form' }
        format.js { render 'shared/show_modal_form' }
      end
    else
      redirect_back_or @sale
    end
  end

  def create
    @sale = Sale.new params[:sale]
    respond_to do |format|
      if @sale.save
        format.html { redirect_back_or root_path, notice: t('sales.created') }
        format.js { render 'save' }
      else
        format.html { render 'form' }
        format.js { flash.now[:error] = @sale.errors.full_messages; render 'save' }
      end
    end
  end

  def update
    @sale = Sale.find params[:id]
    respond_to do |format|
      if @sale.update_attributes params[:sale]
        format.html { redirect_back_or root_path, notice: t('sales.updated') }
        format.js { render 'save' }
      else
        format.html { render 'form' }
        format.js do
          flash.now[:error] = @sale.errors.full_messages
          params[:sale][:payments_attributes].present? ? render('shared/show_modal_form') : render('save')
        end
      end
    end
  end

  def destroy
    @sale = Sale.find params[:id]
    @sale.set_deleted
    respond_to do |format|
      format.html { redirect_to sales_url }
    end
  end

  def post
    @sale = Sale.find params[:id]
    respond_to do |format|
      if @sale.post
        pdf = SaleCheckPdf.new @sale, view_context, params[:copy].present?
        filename = "sale_check_#{@sale.id}.pdf"
        filepath = "#{Rails.root.to_s}/tmp/pdf/#{filename}"
        pdf.render_file filepath
        PrinterTools.print_file filepath, :sale_check
        format.html { redirect_to new_sale_path, notice: t('documents.posted') }
      else
        flash.alert = @sale.errors.full_messages
        format.html { render 'form', error: t('documents.not_posted') }
      end
    end
  end

  def cancel
    @sale = Sale.find params[:id]
    @sale.cancel
    respond_to do |format|
      format.html { redirect_to new_sale_path }
    end
  end

  def print_check
    @sale = Sale.find params[:id]
    if can?(:reprint_check, @sale)
      pdf = SaleCheckPdf.new @sale, view_context, params[:copy].present?
    else
      pdf = SaleCheckPdf.new @sale, view_context, true
    end
    filepath = "#{Rails.root.to_s}/tmp/pdf/sale_check_#{@sale.id}.pdf"
    pdf.render_file filepath
    PrinterTools.print_file filepath, :sale_check, pdf.page_height_mm
    respond_to do |format|
      format.html { redirect_to new_sale_path }
      format.js { render nothing: true }
    end
  end

  def print_warranty
    @sale = Sale.find params[:id]
    pdf = WarrantyPdf.new @sale, view_context
    filename = "sale_warranty_#{@sale.id}.pdf"
    respond_to do |format|
      format.pdf { send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline' }
    end
  end

  def return_check
    source_sale = Sale.find params[:id]
    @sale = source_sale.build_return
    @sale.save
    respond_to do |format|
      format.html { redirect_to edit_sale_path(@sale) }
    end
  end

  def attach_gift_certificate
    @sale = Sale.find params[:id]
    @sale.attach_gift_certificate(params[:number])
    render 'save'
  end

  private

  def sort_column
    Sale.column_names.include?(params[:sort]) ? params[:sort] : 'date'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

end
