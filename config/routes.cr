Marten.routes.draw do
  path "", Website::ROUTES, name: "website"

  if Marten.env.development?
    path "#{Marten.settings.assets.url}<path:path>", Marten::Views::Defaults::Development::ServeAsset, name: "asset"
    path "/404", Marten.settings.view404, name: "404"
    path "/500", Marten.settings.view500, name: "500"
  end
end
