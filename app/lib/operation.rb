module Operation

  class Base < Trailblazer::Operation
    include Trailblazer::Operation::Policy
    include Model

    def model_name
      model.model_name.element
    end

    class << self

      def model!(model_class = nil)
        model_class ||= self.parents[-2]
        action = self.name.demodulize == 'Create' ? :create : :find
        self.model model_class, action
      end

      def policy!(policy_class = nil)
        policy_class ||= "#{self.parent_name}::Policy".safe_constantize
        action = "#{self.name.demodulize.underscore}?"
        self.policy policy_class, action
      end

      def contract!
        contract_class ||= begin
          base_name = "#{self.parent_name}::Form"
          action_name = "#{base_name}::#{self.name.demodulize}"
          action_name.safe_constantize || base_name.safe_constantize
        end
        self.contract contract_class
      end
    end
  end

  class Destroy < Base

    def process(_)
      model.destroy
    end
  end

  class Index < Base
    include Collection

    def model_name
      model.model_name.collection
    end
  end

  class Persist < Base

    def process(params)
      model_params = get_model_params params
      validate model_params do
        ActiveRecord::Base.transaction do
          begin
            destroy_nested_resources!(model_params)
            contract.save
          rescue ActiveRecord::Rollback
            invalid!
          end
        end
      end
    end

    private

    def get_model_params(params)
      model_params = params[model.model_name.param_key.to_sym]
      model_params.permit! if model_params.respond_to?(:permit!)
      model_params
    end

    def destroy_nested_resources!(params)
      nested_params = params.keep_if { |_, value| value.is_a?(Array) && value.first.is_a?(Hash) }
      nested_params.each do |resources_name, resources_params|
        ids = resources_params.collect do |resource_params|
          resource_params['id'] if resource_params['_destroy'].eql?('1')
        end.compact

        model.send(resources_name).where(id: ids).destroy_all
        contract.send(resources_name).reject! { |item| ids.include? item.id }
      end
    end
  end
end