class ContactsExtractionsController < ApplicationController

  def new
  end

  def create
    @contacts_extractor = ContactsExtractor.new contacts_file
    contacts_card = @contacts_extractor.perform
    send_file contacts_card, type: 'application/vcf', filename: 'contacts.vcf', disposition: 'inline'
  end

  private

  def contacts_file
    FileLoader.rename_uploaded_file params[:contacts_file] if params[:contacts_file].present?
  end

end
