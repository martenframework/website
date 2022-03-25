Marten.routes.draw do
  path "", Website::ROUTES, name: "website"

  if Marten.env.development?
    path "#{Marten.settings.assets.url}<path:path>", Marten::Views::Defaults::Development::ServeAsset, name: "asset"
  end
end
