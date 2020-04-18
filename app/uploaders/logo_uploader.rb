class LogoUploader < ApplicationUploader
  def extension_white_list
    %w(jpg jpeg)
  end
end
