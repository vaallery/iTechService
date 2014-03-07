class UserApi < Grape::API
  version 'v1', using: :path

  before { authenticate! }

  desc 'Show client info'
  get 'profile' do
    present current_user
  end

end