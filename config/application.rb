require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fman
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # By default only files in /app and /node_modules are browserified,
    config.browserify_rails.commandline_options = ["-t coffeeify --extension=\".coffee\"", "-t vueify --extension=\".js.vue\""]
  end
end
