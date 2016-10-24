module ItechService
  class Operation::Destroy < Operation

    def process(_)
      model.destroy
    end
  end
end