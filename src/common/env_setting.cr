module EnvSetting
  extend self

  class NotFoundError < Exception; end

  # :nodoc:
  ENV_SETTING_NIL = "_env_setting_nil_"

  def fetch(setting : String | Symbol, default = ENV_SETTING_NIL) : String
    ENV.fetch(setting.to_s) do
      if default == ENV_SETTING_NIL
        raise NotFoundError.new("Set the #{setting} environment variable")
      else
        default
      end
    end
  end
end
