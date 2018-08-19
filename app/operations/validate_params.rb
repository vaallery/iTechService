class ValidateParams < AnOperation
  def call(params, contract)
    result = contract.(params)
    result.success? ? Success(result.output) : Failure(result.messages)
  end
end
