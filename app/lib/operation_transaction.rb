class OperationTransaction
  extend Uber::Callable

  def self.call(*)
    ActiveRecord::Base.transaction { yield }
  end
end