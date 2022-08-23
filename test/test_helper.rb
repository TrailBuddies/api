require 'simplecov'
require 'simplecov_json_formatter'
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...


  setup do
    @user_matievisthekat = users(:matievisthekat)
    @user_test = users(:test)

    # initialize tokens
    @user_matievisthekat.generate_token(true)
    @user_test.generate_token(true)

    # initialize confirm emails keys
    @user_matievisthekat.create_confirm_email_key
    @user_test.create_confirm_email_key
  end
end
