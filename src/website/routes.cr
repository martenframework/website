module Website
  ROUTES = Marten::Routing::Map.draw do
    path "/", HomeView, name: "home"
  end
end
