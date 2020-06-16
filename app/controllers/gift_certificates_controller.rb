class GiftCertificatesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    authorize GiftCertificate
    @gift_certificates = policy_scope(GiftCertificate)
                           .search(params).order("#{sort_column} #{sort_direction}").page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @gift_certificates }
      format.js { render 'shared/index' }
    end
  end

  def show
    @gift_certificate = find_record GiftCertificate

    respond_to do |format|
      format.html
    end
  end

  def new
    @gift_certificate = authorize GiftCertificate.new

    respond_to do |format|
      format.html
      format.json { render json: @gift_certificate }
    end
  end

  def edit
    @gift_certificate = find_record GiftCertificate
  end

  def create
    @gift_certificate = authorize GiftCertificate.new(params[:gift_certificate])

    respond_to do |format|
      if @gift_certificate.save
        format.html do
          @gift_certificate = GiftCertificate.new nominal: @gift_certificate.nominal
          flash.now[:notice] = t('gift_certificates.created')
          render 'new', notice: t('gift_certificates.created')
          #redirect_to gift_certificates_path, notice: 'Gift certificate was successfully created.'
        end
        format.json { render json: @gift_certificate, status: :created, location: @gift_certificate }
      else
        format.html { render action: "new" }
        format.json { render json: @gift_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @gift_certificate = find_record GiftCertificate

    respond_to do |format|
      if @gift_certificate.update_attributes(params[:gift_certificate])
        format.html { redirect_to gift_certificates_path, notice: t('gift_certificates.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gift_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @gift_certificate = find_record GiftCertificate
    @gift_certificate.destroy

    respond_to do |format|
      format.html { redirect_to gift_certificates_url }
      format.json { head :no_content }
    end
  end

  def scan
    @gift_certificate = find_by_number

    if @gift_certificate.present?
      @operation = params[:operation]
      if (@operation == 'issue') and !@gift_certificate.available?
        @error = t 'gift_certificates.errors.not_available'
      elsif (@operation == 'activate') and !@gift_certificate.issued?
        @error = t 'gift_certificates.errors.not_issued'
      else
        @form_path = (@operation == 'issue') ? issue_gift_certificates_path : activate_gift_certificates_path
      end
    else
      @error = t 'gift_certificates.errors.not_found'
    end
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def find
    @gift_certificate = find_by_number params[:id]
    respond_to do |format|
      format.js
    end
  end

  def issue
    @gift_certificate = find_by_number

    respond_to do |format|
      if @gift_certificate.present?
        if @gift_certificate.issue
          msg = flash.now[:notice] = I18n.t('gift_certificates.issued', nominal: @gift_certificate.nominal)
          format.html { redirect_to gift_certificates_path, notice: msg }
          format.js { render 'status_changed' }
        else
          msg = flash.now[:alert] = @gift_certificate.errors.full_messages.join '. '
          format.html { redirect_to gift_certificates_path, alert: msg }
          format.js { render 'error' }
        end
      else
        msg = flash.now[:alert] = t('gift_certificates.errors.not_found')
        format.html { redirect_to gift_certificates_path, alert: msg }
        format.js { render 'error' }
      end
    end
  end

  def activate
    @gift_certificate = find_by_number

    respond_to do |format|
      if @gift_certificate.present?
        if @gift_certificate.update_attributes consume: params[:consume].to_i
          msg = flash.now[:notice] = @gift_certificate.used? ?
                    I18n.t('gift_certificates.activated', nominal: @gift_certificate.nominal) :
                    I18n.t('gift_certificates.consumed', value: params[:consume], balance: @gift_certificate.balance)
          pdf = GiftCertificatePdf.new @gift_certificate, view_context, params[:consume]
          filename = "cert_#{@gift_certificate.number}.pdf"
          if Rails.env.production?
            filepath = "#{Rails.root.to_s}/tmp/pdf/#{filename}"
            pdf.render_file filepath
            system 'lp', filepath
            format.html { redirect_to gift_certificates_path, notice: msg }
          else
            format.html { send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline' }
          end
          format.js { render 'status_changed' }
        else
          msg = flash.now[:alert] = @gift_certificate.errors.full_messages.join '. '
          format.html { redirect_to gift_certificates_path, alert: msg }
          format.js { render 'error' }
        end
      else
        msg = flash.now[:alert] = t('gift_certificates.errors.not_found')
        format.html { redirect_to gift_certificates_path, alert: msg }
        format.js { render 'error' }
      end
    end
  end

  def refresh
    @gift_certificate = find_record GiftCertificate

    respond_to do |format|
      if @gift_certificate.refresh
        msg = flash.now[:notice] = t('gift_certificates.refreshed', nominal:  @gift_certificate.nominal)
        format.html { redirect_to gift_certificates_path, notice: msg }
        format.js { render 'status_changed' }
      else
        msg = flash.now[:alert] = @gift_certificate.errors.full_messages.join '. '
        format.html { redirect_to gift_certificates_path, alert: msg }
        format.js { render 'error' }
      end
    end
  end

  def history
    gift_certificate = find_record GiftCertificate
    @records = gift_certificate.history_records
    render 'shared/show_history'
  end

  private

  def find_by_number(number = params[:number])
    authorize policy_scope(GiftCertificate).find_by_number(number)
  end

  def sort_column
    GiftCertificate.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
