Dotenv.load

ENV_SETTING_NIL = "_env_setting_nil_"

def get_env_setting(setting : String | Symbol, default = ENV_SETTING_NIL) : String
  ENV.fetch(setting.to_s) do
    if default == ENV_SETTING_NIL
      raise "Set the #{setting} environment variable"
    else
      default
    end
  end
end

Marten.configure do |config|
  config.secret_key = get_env_setting(:SECRET_KEY)

  config.installed_apps = [
    Website::App,
  ]

  config.database do |db|
    db.backend = :sqlite
    db.name = Path["website.db"].expand
  end

  config.assets.app_dirs = false
end
