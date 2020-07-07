class AppLogoUploader < ApplicationUploader
  def store_dir
    'uploads'
  end

  def extension_white_list
    ['png']
  end
end
