class FaultKind < ApplicationRecord

  class Create < Operation::Persist
    model FaultKind, :create
    policy FaultKind::Policy, :create?
    contract FaultKind::Form
  end

  class Update < Operation::Persist
    model FaultKind, :update
    policy FaultKind::Policy, :update?
    contract FaultKind::Form
  end

  class Destroy < Operation::Destroy
    model FaultKind, :find
    policy FaultKind::Policy, :destroy?
  end
end