class SubstitutePhone < ApplicationRecord
  module Substitution
    class Update < Operation::Persist
      model PhoneSubstitution, :find
      policy Policy, :update?
      contract Contract

      def process(params)
        model_params = get_model_params params
        validate model_params do
          PhoneSubstitution.transaction do
            begin
              model.substitute_phone.service_job_id = nil
              model.substitute_phone.save
              model.receiver = params[:current_user]
              model.withdrawn_at = Time.current
              contract.save
            rescue ActiveRecord::Rollback
              invalid!
            end
          end
        end
      end

      private

      # def setup_model!(params)
      #   # substitute_phone = SubstitutePhone.find params[:substitute_phone_id]
      #   # model.substitute_phone = substitute_phone
      #   # model.service_job = substitute_phone.service_job
      # end
    end
  end
end