Marten.configure :production do |config|
  config.debug = false
  config.host = "0.0.0.0"

  config.assets.dirs = [
    "src/website/assets/build",
  ]
  config.assets.manifests = [
    "src/website/assets/build/manifest.json",
  ]
end
