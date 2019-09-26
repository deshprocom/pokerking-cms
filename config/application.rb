require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PokerkingCms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.i18n.default_locale = 'zh-CN'
    config.time_zone = 'Beijing'
    # config.active_record.default_timezone = :local
    config.action_controller.asset_host = ENV['ASSET_HOST']
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # eager_load
    # auto_load
    config.autoload_paths += [
        Rails.root.join('lib')
    ]

    config.eager_load_paths += [
        Rails.root.join('lib/dp_push')
    ]
  end
end
