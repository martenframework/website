module Website
  ROUTES = Marten::Routing::Map.draw do
    path "/", HomeView, name: "home"
    path "/bad", BadView, name: "bad"
  end
end
