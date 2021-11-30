Dotenv.load?

Marten.configure do |config|
  config.secret_key = EnvSetting.fetch(:SECRET_KEY)

  config.installed_apps = [
    Website::App,
  ]

  config.assets.app_dirs = false
end
