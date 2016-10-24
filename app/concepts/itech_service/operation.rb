module ItechService
  class Operation < Trailblazer::Operation
    include Trailblazer::Operation::Policy
    include Model

    def process(params)
      validate params[model.model_name.param_key.to_sym] do
        contract.save
      end
    end
  end
end