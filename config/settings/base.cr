Dotenv.load?

Marten.configure do |config|
  config.secret_key = EnvSetting.fetch(:SECRET_KEY, "insecure")

  config.installed_apps = [
    Website::App,
  ]

  config.middleware = [
    Marten::Middleware::GZip,
    Marten::Middleware::XFrameOptions,
  ]

  config.assets.app_dirs = false
end
