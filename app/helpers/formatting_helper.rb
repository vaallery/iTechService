module FormattingHelper
  def textile_to_html(text)
    RedCloth.new(text).to_html if text
  end
end
