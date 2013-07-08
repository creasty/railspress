
require 'rubygems'
require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  # Capybara.javascript_driver = :webkit

  RSpec.configure do |config|
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false

    config.include Devise::TestHelpers, type: :controller
  end
end

Spork.each_run do
  FactoryGirl.reload
end
