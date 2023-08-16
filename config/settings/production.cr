Marten.configure :production do |config|
  config.debug = false
  config.host = "0.0.0.0"
  config.allowed_hosts = EnvSetting.fetch(:ALLOWED_HOSTS, "").split(",")
  config.use_x_forwarded_proto = true

  config.strict_transport_security.max_age = 3600

  config.middleware.unshift(
    Raven::Marten::Middleware,
    WWWRedirectMiddleware,
  )

  config.assets.dirs = [
    "src/website/assets/build",
  ]
  config.assets.manifests = [
    "src/website/assets/build/manifest.json",
  ]
end
