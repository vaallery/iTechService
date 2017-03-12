class Fault < ApplicationRecord

  class Create < Operation::Persist
    model Fault, :create
    policy Fault::Policy, :create?
    contract Fault::Form

    private

    def setup_model!(params)
      user = User.find params[:user_id]
      model.causer = user
    end
  end

  class Update < Operation::Persist
    model Fault, :update
    policy Fault::Policy, :update?
    contract Fault::Form
  end

  class Destroy < Operation::Destroy
    model Fault, :find
    policy Fault::Policy, :destroy?
  end
end