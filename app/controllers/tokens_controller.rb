class TokensController < ActionController::Base
  protect_from_forgery
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    username = params[:username]
    password = params[:password]

    unless request.format.json?
      render status: 406, json: {message: "The request must be json"}
      return
    end

    if username.blank? or password.blank?
      render status: 400, json: {message: "The request must contain the username and password."}
      return
    end

    @user = User.find_first_by_auth_conditions auth_token: username.downcase

    if @user.nil?
      logger.info "User #{username} faild signin, user cannot be found."
      render status: 401, json: {message: "Invalid email or password"}
      return
    end

    @user.ensure_authentication_token!

    unless @user.valid_password? password
      logger.info "User #{username} failed signin, password is invalid."
      render status: 401, json: {message: "Invalid email or password."}
    else
      render status: 200, json: {token: @user.authentication_token}.merge(@user.as_json)
    end
  end

  def destroy
    @user = User.find_by_authentication_token params[:id]
    if @user.nil?
      logger.info "Token not found."
      render status: 404, json: {message: "Invalid token."}
    else
      @user.reset_authentication_token!
      render status: 200, json: {token: params[:id]}
    end
  end
end
