require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RubyJobfair01
  class Application < Rails::Application
    config.load_defaults 5.2

    config.i18n.default_locale = :en
    config.generators.system_tests = nil
  end
end
