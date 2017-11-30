Kaminari.configure do |config|
  config.default_per_page = 20
  # config.max_per_page = nil
  config.window = 3
  config.outer_window = 3
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end

Kaminari::Helpers::Paginator.class_eval do
  def render(&block)
    instance_eval(&block) if @options[:total_pages] > 1
    # @output_buffer
  end
end