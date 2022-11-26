Dotenv.load?

Marten.configure do |config|
  config.secret_key = EnvSetting.fetch(:SECRET_KEY, "insecure")

  config.installed_apps = [
    Website::App,
  ]

  config.middleware = [
    Marten::Middleware::GZip,
    Marten::Middleware::XFrameOptions,
    Marten::Middleware::StrictTransportSecurity,
  ]

  config.assets.app_dirs = false

  config.templates.context_producers.unshift(Website::GoogleSiteVerificationCodeContextProducer)

  config.website.discord_invitation_link = "https://discord.gg/499Vwt6kTc"
  config.website.google_site_verification_code = EnvSetting.fetch(:GOOGLE_SITE_VERIFICATION_CODE, "notset")
end
