Dotenv.load

Marten.configure do |config|
  config.secret_key = EnvSetting.fetch(:SECRET_KEY)

  config.installed_apps = [
    Website::App,
  ]

  config.database do |db|
    db.backend = :sqlite
    db.name = Path["website.db"].expand
  end

  config.assets.app_dirs = false
end
