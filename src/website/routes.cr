module Website
  ROUTES = Marten::Routing::Map.draw do
    path "/", HomeHandler, name: "home"
    # path "/bad", BadHandler, name: "bad"
  end
end
