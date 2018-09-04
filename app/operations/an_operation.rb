require 'dry/monads/result'
require 'dry/matcher'
require 'dry/matcher/result_matcher'

class AnOperation
  include Dry::Monads::Result::Mixin
  include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
end
