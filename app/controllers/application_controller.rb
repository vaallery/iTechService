class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  protect_from_forgery
  # before_action :auto_sign_in
  before_filter :authenticate_user!
  before_filter :set_current_user
  before_filter :store_location, except: [:create, :update, :destroy]
  # layout 'staff'
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from CanCan::AccessDenied, with: :access_denied
  respond_to :html

  protected

  def run(operation, params=self.params, *dependencies)
    result = operation.(
      _run_params(params),
        *_run_runtime_options(*dependencies)
    )

    @contract = result["contract.default"]
    @form = result["contract.default"]
    # @form  = Trailblazer::Rails::Form.new(@contract, result["model"].class)
    @model = result["model"]

    # TODO: get rid of it, use cells
    unless @model.nil?
      model_variable_name = action_name == 'index' ? @model.model_name.collection : @model.model_name.element
      instance_variable_set "@#{model_variable_name}", @model
    end

    yield(result) if result.success? && block_given?

    @_result = result
  end

  def render_cell(cell_class, model: nil, **options)
    model ||= @model
    # options[:layout] = Shared::Cell::Layout unless options.key? :layout
    # options[:contract] = @form unless @form.nil?
    options[:contract] = @contract unless @contract.nil?
    content = cell(cell_class, model, options).call

    if request.xhr?
      render js: "document.getElementById('remote_container').innerHTML = '#{content}'"
    else
      render html: content, layout: true
    end
  end

  private

  def auto_sign_in
    if Rails.env.development?
      user = User.find_by(username: 'vova')
      sign_in user if user.present?
    end
  end

  def set_current_user
    User.current = current_user
  end

  def params!(params)
    params.merge current_user: current_user
  end

  def not_authorized
    # policy_name = exception.policy.class.to_s.underscore
    # message = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    message = 'Access denied'
    if request.xhr?
      render js: "App.Notification.show('#{message}', 'alert');"
    else
      flash[:alert] = message
      redirect_to request.referrer || root_path
    end
  end

  def access_denied
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    flash[:error] = exception.message
    redirect_to request.referrer || root_url, alert: exception.message
  end

  def _run_options(options)
    options.merge 'current_user' => current_user
  end

  def failed(message = nil)
    message ||= operation_message
    if request.xhr?
      render_error message
    else
      flash.alert = message
      redirect_to request.referrer || root_path
    end
  end

  def operation_model
    result['model']
  end

  def operation_message
    result['result.message']
  end

  def operation_failed?
    result.failure?
  end

  def redirect_to_index(response_status={})
    redirect_to({action: :index}, response_status)
  end

  # def render_object_errors(object)
  #   render_error object.errors.full_messages.to_sentence
  # end

  def render_error(text)
    render_notification text, 'alert'
  end

  def render_notification(text, type='info')
    render js: "alert('#{text}');"
    # render js: "App.Notification.show('#{text}', '#{type}');"
  end
end
