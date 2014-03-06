class API < Grape::API
  prefix 'api'
  format :json
  default_format :json
  REALM = 'ise_api'

  helpers do
    def current_user
      #@current_user ||= User.authorize!(env)
      authenticate_or_request_with_http_token do |token, options|
        @current_user = User.active.find_by_authentication_token token
      end
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end
  end

  #http_digest({realm: 'ContactsKeeper', opaque: 'app secret'}) do |username|
  http_basic do |username|
    users_hash[username]
  end

  mount Token


end