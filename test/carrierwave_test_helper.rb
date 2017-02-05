require 'fileutils'

module CarrierWaveTestHelper
  CARRIERWAVE_TEMPLATE = Rails.root.join('test', 'fixtures', 'files')
  CARRIERWAVE_ROOT = Rails.root.join('test', 'support', 'carrierwave')

  CarrierWave.configure do |config|
    config.root = CARRIERWAVE_ROOT
    config.enable_processing = false
    config.storage = :file
    config.cache_dir = Rails.root.join('test', 'support', 'carrierwave', 'carrierwave_cache')
  end

  # FileUtils.cp_r CARRIERWAVE_TEMPLATE.join('uploads'), CARRIERWAVE_ROOT

  def image_file_name
    @image_file_name ||= Rails.root.join 'test', 'fixtures', 'files', 'image-2560x1440.jpg'
  end

  def image_file
    @image_file ||= File.new image_file_name
  end

  def create_file(size=1)
    file_name = CarrierWaveTestHelper::CARRIERWAVE_ROOT.join('big_file.dat')
    File.open(file_name, 'wb') do |f|
      f.seek(size-1)
      f.write "\0"
    end
    File.open file_name
  end

  # at_exit do
  def teardown
    super
    Dir.glob(CARRIERWAVE_ROOT.join('*')).each do |dir|
      FileUtils.remove_entry dir
    end
  end
end