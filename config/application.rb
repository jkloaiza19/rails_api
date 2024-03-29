# require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApi
  class Application < Rails::Application
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
    # config.autoload_paths << Rails.root.join('lib')
    config.paths.add Rails.root.join('lib').to_s, eager_load: true
     config.eager_load_paths += %W(
      #{config.root}/lib/exception_errors
      #{config.root}/lib/firebase
      #{config.root}/app/serializers/concerns
    )
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # config.autoload_paths += %W(#{config.root}/lib/**/)
    # config.autoload_paths += Dir["#{config.root}/lib/**/"]
    # config.autoload_paths += %W(#{config.root}/lib/ExceptionErrors/ExceptionErrors::NotFound)

    #   config.middleware.insert_before 0, Rack::Cors do
  #     allow do
  #       origins '*'
  #       resource(
  #         '*',
  #         headers: :any,
  #         expose: ["Authorization"],
  #         methods: [:get, :patch, :put, :delete, :post, :options, :show]
  #       )
  #     end
  #  end
  end
end
