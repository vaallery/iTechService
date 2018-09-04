module ACallable
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  def call(*)
    raise NotImplementedError, 'override me'
  end

  module ClassMethods
    def call(*args, &block)
      if block_given?
        new.(*args, &block)
      else
        new.(*args)
      end
    end
  end
end
