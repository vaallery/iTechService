# encoding: utf-8

class OrderPictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  permissions 0777

  def default_url
     "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  version :medium do
    process resize_to_fill: [300, 300]
  end

  def extension_white_list
     %w(jpg jpeg gif png)
  end
end
