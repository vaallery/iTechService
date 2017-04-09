module Authorizable
  extend ActiveSupport::Concern

  included do
    delegate :policy_class, to: :class
  end

  class_methods do
    def policy_class
      class_name = respond_to?(:model_name) ? model_name : name
      "#{class_name}::Policy".constantize
    end
  end
end