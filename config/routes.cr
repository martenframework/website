Marten.routes.draw do
  path "", Website::ROUTES, name: "website"

  if Marten.env.development?
    path "#{Marten.settings.assets.url}<path:path>", Marten::Handlers::Defaults::Development::ServeAsset, name: "asset"
    path "/404", Marten.settings.handler404, name: "404"
    path "/500", Marten.settings.handler500, name: "500"
  end
end
