module Website
  ROUTES = Marten::Routing::Map.draw do
    path "/", HomeHandler, name: "home"
    path "/chat", ChatHandler, name: "chat"
    path "/code-of-conduct", CodeOfConductHandler, name: "code_of_conduct"
    path "/robots.txt", RobotsHandler, name: "robots"
    # path "/bad", BadHandler, name: "bad"
  end
end
