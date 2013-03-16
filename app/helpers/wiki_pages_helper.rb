module WikiPagesHelper
  acts_as_wiki_pages_helper

  def wiki_page_attachments(page = @page)
    return unless Irwi::config.page_attachment_class_name

    page.attachments.each do |attachment|
      concat image_tag(attachment.wiki_page_attachment.url(:thumb))
      concat " Attachment_#{attachment.id}"
      concat link_to(t('wiki.remove'), wiki_remove_page_attachment_path(attachment.id), method: :delete,
             class: 'btn btn-small btn-danger')
      concat tag(:br)
      concat "#{t('wiki.attachment_url')}: \"#{attachment.wiki_page_attachment.url}\""
      concat tag(:hr)
    end
    form_for(Irwi.config.page_attachment_class.new,
             :as => :wiki_page_attachment,
             :url => wiki_add_page_attachment_path(page),
             :html => { :multipart => true }) do |form|
      concat form.file_field :wiki_page_attachment
      concat form.hidden_field :page_id, :value => page.id
      concat form.submit t('wiki.add_attachment')
    end
  end

end
