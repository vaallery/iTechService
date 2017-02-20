ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/reporters'
require 'mocha/mini_test'

require 'minitest/rails/capybara'
require 'capybara/poltergeist'
require 'minitest-metadata'

require 'common_test_helper'
require 'acceptance_test_helper'
require 'carrierwave_test_helper'

Minitest::Reporters.use! [Minitest::Reporters::RubyMineReporter]

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new app, window_size: [1200, 768]
end
Capybara.javascript_driver = :poltergeist

class CommonTest < ActiveSupport::TestCase
  include CommonTestHelper
  include CarrierWaveTestHelper
end

class IntegrationTest < ActionDispatch::IntegrationTest
  include CommonTestHelper
  include Devise::TestHelpers
  # include Devise::Test::ControllerHelpers
  # include Devise::Test::IntegrationHelpers
end

class AcceptanceTest < Capybara::Rails::TestCase
  include AcceptanceTestHelper
  include CommonTestHelper
  include ApplicationHelper

  before do
    metadata[:js] ? enable_js : disable_js
  end
end

class PolicyTest < ActiveSupport::TestCase

  def assert_permissions(user, record, available_actions, permissions_hash = {})
    permissions_hash.each do |action, should_be_permitted|
      if should_be_permitted
        assert_permit user, record, action
      else
        refute_permit user, record, action
      end
    end

    unused_actions = available_actions - permissions_hash.keys
    assert unused_actions.empty?, "The following actions were not tested: #{unused_actions}"

    unavailable_actions = permissions_hash.keys - available_actions
    assert unavailable_actions.empty?, "The following actions were tested, but not in available_actions: #{unavailable_actions}"
  end

  def assert_permit(user, record, action)
    assert permit(user, record, action), "User #{user} should be permitted #{action} on #{record}, but isn't"
  end

  def refute_permit(user, record, action)
    refute permit(user, record, action), "User #{user} should not be permitted #{action} on #{record}, but he does"
  end

  def permit(user, record, action)
    record.policy_class.new(user, record).public_send("#{action.to_s}?")
  end
end