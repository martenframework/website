Marten.configure :production do |config|
  config.debug = false
  config.host = "0.0.0.0"

  config.basic_auth.username = EnvSetting.fetch(:BASIC_AUTH_USERNAME, "insecure")
  config.basic_auth.password = EnvSetting.fetch(:BASIC_AUTH_PASSWORD, "insecure")

  config.middleware = [
    BasicAuthMiddleware,
  ]

  config.assets.dirs = [
    "src/website/assets/build",
  ]
  config.assets.manifests = [
    "src/website/assets/build/manifest.json",
  ]
end
