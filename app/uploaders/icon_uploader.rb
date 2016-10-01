class IconUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # process resize_to_fill: []

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end