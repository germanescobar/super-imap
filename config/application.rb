require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SuperIMAP
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += Dir["#{config.root}/app/interactors"]
    config.autoload_paths += Dir["#{config.root}/app/processes"]
    config.autoload_paths += Dir["#{config.root}/app/workers"]

    encryption_key = ENV['ENCRYPTION_KEY']
    if encryption_key.present?
      config.encryption_cipher = Gibberish::AES.new(encryption_key)
    else
      config.encryption_cipher = nil
    end

    config.log_level = String(ENV['LOG_LEVEL'] || "info").upcase

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/api/v1/*',
          headers: ['Origin', 'Accept', 'Content-Type', 'x-api-key'],
          methods: [:get, :post, :put]

        resource '/users/*',
          headers: ['Origin', 'Accept', 'Content-Type'],
          methods: [:get]
      end
    end
  end
end
