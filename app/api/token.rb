class Token < Grape::API
  version 'v1', using: :path

  desc 'Sings in user and creates auth token'
  params do
    requires :username
    requires :password
  end
  post '/signin' do
    username = params[:username]
    password = params[:password]

    if (user = User.find_first_by_auth_conditions auth_token: username.downcase).present?

      #user.reset_authentication_token!
      user.ensure_authentication_token!

      if user.valid_password? password
        {token: user.authentication_token}.merge(user.as_json)
      else
        error!({message: "Invalid password."}, 401)
      end
    else
      error!({message: "Invalid username or password."}, 401)
    end
  end

  #rescue_from :all

  desc 'Sings out user and resets auth token'
  delete '/signout' do
    authenticate!
    current_user.reset_authentication_token!
    {token: params[:token]}
  end

  #rescue_from :all

end