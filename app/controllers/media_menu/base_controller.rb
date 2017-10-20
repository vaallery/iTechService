module MediaMenu
  class BaseController < ActionController::Base
    include Operation
    include RenderCell
    protect_from_forgery
  end
end
