class GiftCertificatesController < ApplicationController
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource
  skip_load_resource only: [:index, :issue, :activate]

  def index
    @gift_certificates = GiftCertificate.search(params).order(sort_column + ' ' + sort_direction).page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @gift_certificates }
      format.js { render 'shared/index' }
    end
  end

  def show
    @gift_certificate = GiftCertificate.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  def new
    @gift_certificate = GiftCertificate.new

    respond_to do |format|
      format.html
      format.json { render json: @gift_certificate }
    end
  end

  def edit
    @gift_certificate = GiftCertificate.find(params[:id])
  end

  def create
    @gift_certificate = GiftCertificate.new(params[:gift_certificate])

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
    @gift_certificate = GiftCertificate.find(params[:id])

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
    @gift_certificate = GiftCertificate.find(params[:id])
    @gift_certificate.destroy

    respond_to do |format|
      format.html { redirect_to gift_certificates_url }
      format.json { head :no_content }
    end
  end

  def issue
    respond_to do |format|
      if (@gift_certificate = GiftCertificate.find_by_number params[:number]).present?
        if @gift_certificate.update_attributes status: 1
          msg = flash.now[:notice] = t('gift_certificates.issued', nominal: @gift_certificate.nominal_h)
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
    respond_to do |format|
      if (@gift_certificate = GiftCertificate.find_by_number params[:number]).present?
        if @gift_certificate.update_attributes status: 2
          msg = flash.now[:notice] = t('gift_certificates.activated', nominal: @gift_certificate.nominal_h)
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

  def refresh
    @gift_certificate = GiftCertificate.find params[:id]

    respond_to do |format|
      if @gift_certificate.update_attributes status: 0
        msg = flash.now[:notice] = t('gift_certificates.refreshed', nominal:  @gift_certificate.nominal_h)
        format.html { redirect_to gift_certificates_path, notice: msg }
        format.js { render 'status_changed' }
      else
        msg = flash.now[:alert] = @gift_certificate.errors.full_messages.join '. '
        format.html { redirect_to gift_certificates_path, alert: msg }
        format.js { render 'error' }
      end
    end
  end

  private

  def sort_column
    Device.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

end
